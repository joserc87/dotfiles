#!/usr/bin/env python3
"""
deploy_diff.py — which commit of each smart-topics service is live in dev/stg/prod.

SAFETY NOTICE: this script only ever READS.
  - AWS SSM  : get-parameters (explicit names only — never by-path/recursive)
  - AWS Lambda / ECS: get-function, describe-services, describe-task-definition
  - Git      : ls-files, rev-parse, rev-list, log, show, merge-base
  - `git fetch origin <branch>` updates remote refs only; the working tree,
    the index and the current branch are never touched.
  No put-parameter, no update-function-code, no commit/push/tag/delete.

WHY THIS EXISTS
---------------
Every deployable project in the backend monorepo ships an artifact tagged
`<short-sha>-<pipeline-iid>`. That tag is the only link between "what is running
in prod" and "which commit that is". This script follows the link for every
project at once and prints either a drift matrix or a per-service commit log.

WHERE THE DEPLOYED VERSION ACTUALLY LIVES
-----------------------------------------
There is no single answer, and getting this wrong is how you confidently report
a version that has not been deployed for months. The source depends on which CI
generation owns the project (see references/deployment-sources.md):

  Pipelines v1 (RavenPackCITemplates, `.git_config.yml` has `deploy_method:`)
      The deploy script writes an SSM parameter under /<account>/{lambda,ecs}/...
      That parameter IS the ledger. Authoritative.

  Pipelines v2 (pipeline-templates, `.git_config.yml` has a template `file:`)
      Writes NO SSM parameter. Any SSM parameter still sitting at the v1 path is
      a fossil from before the migration and must be ignored — e.g. dev
      /ecs/st-search-monitoring-worker/image was last written 2026-07-28 while
      the service has been redeployed many times since. For v2 we read the live
      resource instead:
          docker→lambda  : Lambda Code.ImageUri tag
          docker→ecs-*   : ECS service task definition container image tag
          docker→eks     : NOT covered here — needs kubectl and a namespace map;
                           use lambda/st_agents_workflows/pipeline_diff.sh
          zip→lambda     : NOT RESOLVABLE — a v2 zip deploy leaves no version
                           marker on the function (no tag, no description, and
                           Code.Location is an opaque snapshot URL). Reported as
                           "unknown", never guessed.

For projects that have BOTH an SSM parameter and a live source, the live source
wins and a disagreement is reported — that is a failed deploy, a manual
rollback, or a stale parameter, and it is worth seeing.

A commit tag only tells you which commit BUILT the artifact. In a monorepo that
commit usually changed something else entirely, so each deployed commit is
mapped to the newest commit at-or-before it that touched the service's own code:
its project directory plus the first-party path dependencies resolved in its
poetry.lock (the "main" group — the closure the build actually installs).
"""

from __future__ import annotations

import argparse
import concurrent.futures as cf
import fnmatch
import json
import os
import re
import shutil
import subprocess
import sys
from dataclasses import dataclass, field
from datetime import datetime, timezone
from pathlib import Path

try:
    import tomllib
except ModuleNotFoundError:  # pragma: no cover - only on <3.11 without tomli
    try:
        import tomli as tomllib  # type: ignore
    except ModuleNotFoundError:
        tomllib = None  # type: ignore

# --------------------------------------------------------------------------- #
# Configuration
# --------------------------------------------------------------------------- #

ENVS = ("dev", "stg", "prod")
ACCOUNT_FMT = "smart-topics-{env}-nvirginia"
PROFILE_FMT = "smart-topics-{env}-nvirginia"  # read-only by default
REGION = os.environ.get("DEPLOY_DIFF_REGION", "us-east-1")
DEFAULT_REPO = Path.home() / "git" / "python" / "smart-topics"
DEFAULT_BRANCH = "master"

# Squad ownership. Read from each project's pyproject.toml
# ([tool.poetry].maintainers) and applied by default so a bare run reports the
# squad's own services instead of all 60 in the monorepo. Override with
# --maintainer NAME, or --maintainer all to report everything. An explicit
# --service always wins over this filter.
DEFAULT_MAINTAINER = "tase"
MAINTAINERS_RE = re.compile(r"^\s*maintainers\s*=\s*\[(.*?)\]", re.MULTILINE | re.DOTALL)

# `aws ssm get-parameters` rejects more than 10 names per call.
SSM_BATCH = 10

# v1 deploy script -> (ssm path templates, platform). The first template that
# actually exists in SSM wins; the alternates exist because some deploy scripts
# hyphenate APPLICATION_NAME and others do not.
V1_DEPLOY_METHODS = {
    "bigdata_backend_deploy.sh": (["lambda/{hy}/zip-name"], "lambda-zip"),
    "bigdata_lambda_ecr_deploy.sh": (
        ["lambda/{app}/image-version", "lambda/{hy}/image-version"],
        "lambda-image",
    ),
    "bigdata_ecs_deploy_v2.sh": (["ecs/{hy}/image", "ecs/{app}/image"], "ecs"),
    "bigdata_ecs_task_definition_deploy.sh": (
        ["ecs/{app}/image-version", "ecs/{hy}/image-version"],
        "ecs",
    ),
}

# v2 template path -> (platform, live resolver or None, reason when None)
V2_TEMPLATES = {
    "build-docker-deploy-lambda": ("lambda-image", "lambda-image", None),
    "build-docker-deploy-ecs-fargate": ("ecs", "ecs-image", None),
    "build-docker-deploy-ecs-ec2": ("ecs", "ecs-image", None),
    "build-docker-deploy-eks": (
        "eks",
        None,
        "EKS deployment — read it with kubectl "
        "(lambda/st_agents_workflows/pipeline_diff.sh covers these)",
    ),
    "build-zip-deploy-lambda": (
        "lambda-zip",
        None,
        "pipelines-v2 zip deploy leaves no version marker on the function",
    ),
    "build-docker-deploy-beanstalk": (
        "beanstalk",
        None,
        "Beanstalk application version is not tracked here",
    ),
}

# Stderr fingerprints that mean "your AWS session is dead" rather than "the
# thing you asked for does not exist". Without this distinction an expired SSO
# login looks exactly like a fleet of undeployed services.
AUTH_RE = re.compile(
    r"ExpiredToken|Token has expired|token is expired"
    r"|security token included in the request is expired"
    r"|Error loading SSO Token|Error when retrieving token from sso"
    r"|SSO session associated with this profile|UnauthorizedSSOTokenError"
    r"|InvalidGrantException|InvalidClientTokenId|Unable to locate credentials"
    r"|NoCredentialProviders|config profile .* could not be found|aws sso login",
    re.IGNORECASE,
)

# A short sha in a version tag is 7-10 hex chars. Pipeline IIDs are decimal.
HEX_RE = re.compile(r"^[0-9a-f]{7,10}$")
DEC_RE = re.compile(r"^[0-9]+$")

NOT_DEPLOYED_VALUES = {"", "-", "none", "null", "n/a"}


class C:
    """ANSI colors, blanked out when stdout is not a terminal."""

    BLUE = "\033[34m"
    ORANGE = "\033[33m"
    RED = "\033[31m"
    GREEN = "\033[32m"
    GREY = "\033[90m"
    BOLD = "\033[1m"
    OFF = "\033[0m"

    @classmethod
    def disable(cls) -> None:
        for name in ("BLUE", "ORANGE", "RED", "GREEN", "GREY", "BOLD", "OFF"):
            setattr(cls, name, "")


def info(msg: str) -> None:
    print(f"{C.BLUE}[info]{C.OFF} {msg}", file=sys.stderr)


def warn(msg: str) -> None:
    print(f"{C.ORANGE}[warn]{C.OFF} {msg}", file=sys.stderr)


def error(msg: str) -> None:
    print(f"{C.RED}[error]{C.OFF} {msg}", file=sys.stderr)


# --------------------------------------------------------------------------- #
# Subprocess helpers
# --------------------------------------------------------------------------- #


def run(cmd: list[str], cwd: Path | None = None) -> tuple[int, str, str]:
    proc = subprocess.run(
        cmd, cwd=str(cwd) if cwd else None, capture_output=True, text=True
    )
    return proc.returncode, proc.stdout.strip(), proc.stderr.strip()


class Git:
    """Every git call is anchored to the repo root so cwd never matters."""

    def __init__(self, root: Path):
        self.root = root
        self._commit_cache: dict[str, dict | None] = {}
        self._ancestor_cache: dict[tuple[str, str], bool] = {}

    def __call__(self, *args: str) -> str:
        rc, out, _ = run(["git", "-C", str(self.root), *args])
        return out if rc == 0 else ""

    def resolve(self, rev: str) -> str | None:
        """Full hash for a rev, or None when it is not a commit we have."""
        out = self(f"--no-pager", "rev-parse", "--verify", "--quiet", f"{rev}^{{commit}}")
        return out or None

    def show(self, full: str) -> dict:
        """date / author / subject for a commit, cached."""
        if full not in self._commit_cache:
            out = self("show", "-s", "--format=%cs%x1f%an%x1f%s", full)
            if out:
                date, author, subject = (out.split("\x1f") + ["", "", ""])[:3]
                self._commit_cache[full] = {
                    "date": date,
                    "author": author,
                    "subject": subject,
                }
            else:
                self._commit_cache[full] = {
                    "date": "unknown",
                    "author": "unknown",
                    "subject": "unknown",
                }
        return self._commit_cache[full]

    def newest_touching(self, rev: str, paths: list[str]) -> str | None:
        """
        Newest commit at-or-before `rev` on the first-parent chain that changed
        anything under `paths`. This is what turns "the commit that built the
        artifact" into "the commit whose code is running".
        """
        out = self("rev-list", "-1", "--first-parent", rev, "--", *paths)
        return out or None

    def commits_between(self, older: str, newer: str, paths: list[str]) -> list[str]:
        """In-scope commits in (older, newer], newest first."""
        out = self("rev-list", "--first-parent", f"{older}..{newer}", "--", *paths)
        return [line for line in out.splitlines() if line]

    def count_between(self, older: str, newer: str, paths: list[str]) -> int:
        out = self("rev-list", "--count", "--first-parent", f"{older}..{newer}", "--", *paths)
        try:
            return int(out)
        except ValueError:
            return 0

    def oldest(self, commits: list[str]) -> str:
        """The commit every other one descends from (or the best available)."""
        return max(commits, key=lambda c: sum(self.is_ancestor(c, o) for o in commits))

    def newest(self, commits: list[str]) -> str:
        """The commit that descends from every other one."""
        return max(commits, key=lambda c: sum(self.is_ancestor(o, c) for o in commits))

    def is_ancestor(self, a: str, b: str) -> bool:
        hit = self._ancestor_cache.get((a, b))
        if hit is None:
            rc, _, _ = run(
                ["git", "-C", str(self.root), "merge-base", "--is-ancestor", a, b]
            )
            hit = rc == 0
            self._ancestor_cache[(a, b)] = hit
        return hit


# --------------------------------------------------------------------------- #
# Service catalogue — discovered from the repo, never hardcoded
# --------------------------------------------------------------------------- #


@dataclass
class Service:
    name: str  # display name, hyphenated (NOT unique — see `key`)
    project: str | None  # repo-relative project dir
    platform: str  # lambda-zip | lambda-image | ecs | eks | ...
    generation: str  # v1 | v2 | override
    source: str | None  # ssm | lambda-image | ecs-image | None
    ssm_candidates: list[str] = field(default_factory=list)
    fn_name: str | None = None  # Lambda function name
    ecs_clusters: dict[str, str] = field(default_factory=dict)  # env -> cluster
    ecs_service: str | None = None
    unresolvable: str | None = None  # why source is None
    note: str | None = None
    scope: list[str] = field(default_factory=list)
    scope_degraded: bool = False
    maintainers: list[str] = field(default_factory=list)
    # Unique handle. Two projects CAN publish the same application_name — e.g.
    # lambda/st_playground still declares application_name: st_public_api while
    # lambda/st_public_api owns it under pipelines v2. Both are real rows, so
    # the display name cannot be the identity.
    key: str = ""


def assign_keys(services: list[Service]) -> list[str]:
    """Give every service a unique key, disambiguating repeated names."""
    notes: list[str] = []
    counts: dict[str, int] = {}
    for svc in services:
        counts[svc.name] = counts.get(svc.name, 0) + 1
    for svc in services:
        if counts[svc.name] == 1:
            svc.key = svc.name
            continue
        suffix = Path(svc.project).name if svc.project else svc.generation
        svc.key = f"{svc.name}@{suffix}"
        notes.append(
            f"application_name {svc.name} is declared by more than one project "
            f"({svc.key} = {svc.project}); if one of them is pipelines-v2, the "
            f"other's SSM parameter is probably a fossil — check before trusting it"
        )
    return notes


def hy(name: str) -> str:
    """The CI's normalize_to_hyphens: underscores become hyphens."""
    return name.replace("_", "-")


def parse_git_config(path: Path) -> dict[str, str]:
    """
    Flat key -> value scrape of a .git_config.yml.

    These files are a single `include:` entry with a flat `inputs:` block, so a
    line scrape is enough and keeps the script dependency-free (no PyYAML). Last
    occurrence of a key wins.
    """
    out: dict[str, str] = {}
    line_re = re.compile(r"^\s*-?\s*([A-Za-z0-9_]+):\s*(.*?)\s*$")
    for raw in path.read_text(encoding="utf-8", errors="replace").splitlines():
        if raw.lstrip().startswith("#"):
            continue
        m = line_re.match(raw)
        if not m:
            continue
        key, val = m.group(1), m.group(2)
        if val.startswith(('"', "'")) and val.endswith(('"', "'")) and len(val) > 1:
            val = val[1:-1]
        else:
            val = val.split(" #", 1)[0].strip()
        if val:
            out[key] = val
    return out


def discover(git: Git) -> tuple[list[Service], list[str]]:
    """
    Build the catalogue from every tracked .git_config.yml in the monorepo.

    Tracked-only (git ls-files) on purpose: an untracked config in a dirty
    working tree is not deploying anything.
    """
    notes: list[str] = []
    services: list[Service] = []

    listed = git("ls-files", "*.git_config.yml")
    configs = [Path(p) for p in listed.splitlines() if p and "/tests/fixtures/" not in p]
    if not configs:
        error("No .git_config.yml files found — is --repo pointing at the backend monorepo?")
        return [], notes

    for rel in configs:
        cfg = parse_git_config(git.root / rel)
        app = cfg.get("application_name")
        if not app:
            continue  # a library project: built, never deployed
        project = str(rel.parent)
        deploy_method = cfg.get("deploy_method")

        if deploy_method:
            templates, platform = V1_DEPLOY_METHODS.get(deploy_method, (None, None))
            if templates is None:
                services.append(
                    Service(
                        name=hy(app),
                        project=project,
                        platform="unknown",
                        generation="v1",
                        source=None,
                        unresolvable=f"unsupported v1 deploy_method {deploy_method}",
                    )
                )
                continue
            candidates = []
            for tpl in templates:
                cand = tpl.format(app=app, hy=hy(app))
                if cand not in candidates:
                    candidates.append(cand)
            services.append(
                Service(
                    name=hy(app),
                    project=project,
                    platform=platform,
                    generation="v1",
                    source="ssm",
                    ssm_candidates=candidates,
                    fn_name=hy(app) if platform.startswith("lambda") else None,
                    ecs_clusters=_ecs_clusters(cfg),
                    ecs_service=(cfg.get("ecs_services") or app).split()[0],
                )
            )
            continue

        # Pipelines v2: the template path is the deploy method.
        tpl_file = cfg.get("file", "")
        kind = next((k for k in V2_TEMPLATES if f"/{k}/" in tpl_file), None)
        if kind is None:
            if "/libraries/" in tpl_file:
                continue
            services.append(
                Service(
                    name=hy(app),
                    project=project,
                    platform="unknown",
                    generation="v2",
                    source=None,
                    unresolvable=f"unrecognised v2 template {tpl_file or '(none)'}",
                )
            )
            continue

        platform, resolver, why = V2_TEMPLATES[kind]
        services.append(
            Service(
                name=hy(app),
                project=project,
                platform=platform,
                generation="v2",
                source=resolver,
                fn_name=hy(app) if platform.startswith("lambda") else None,
                ecs_clusters=_ecs_clusters(cfg),
                ecs_service=(cfg.get("ecs_services") or app).split()[0],
                unresolvable=why,
            )
        )

    # A duplicate SSM path means two projects claim the same ledger entry — the
    # matrix would silently attribute one project's deploys to the other.
    seen: dict[str, str] = {}
    for svc in services:
        for cand in svc.ssm_candidates:
            if cand in seen and seen[cand] != svc.name:
                notes.append(
                    f"SSM path {cand} is claimed by both {seen[cand]} and {svc.name}"
                )
            seen[cand] = svc.name

    return services, notes


def _ecs_clusters(cfg: dict[str, str]) -> dict[str, str]:
    """Per-env ECS cluster: v2 uses <env>_ecs_cluster, v1 a single ecs_cluster."""
    shared = cfg.get("ecs_cluster")
    out = {}
    for env in ENVS:
        out[env] = cfg.get(f"{env}_ecs_cluster") or shared or ""
    return out


def apply_overrides(services: list[Service], path: Path | None) -> list[str]:
    """
    Merge an overrides file for what discovery cannot know.

    Needed because some deployed services have no `.git_config.yml` in this repo
    at all (their CI lives elsewhere) and some SSM leaf names do not match their
    project directory. Shape:

        {
          "services": {
            "<name>": {"ssm": "...", "project": "lambda/...", "platform": "ecs",
                       "ecs_cluster": "...", "ecs_service": "...",
                       "function": "...", "note": "..."}
          },
          "ignore": ["<name>", "glob-*"]
        }
    """
    notes: list[str] = []
    if not path or not path.is_file():
        return notes
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception as exc:  # noqa: BLE001 - a bad overrides file must not be fatal
        warn(f"Ignoring unreadable overrides file {path}: {exc}")
        return notes

    by_name = {s.name: s for s in services}
    for name, spec in (data.get("services") or {}).items():
        svc = by_name.get(name)
        if svc is None:
            svc = Service(
                name=name,
                project=spec.get("project"),
                platform=spec.get("platform", "unknown"),
                generation="override",
                source=None,
            )
            services.append(svc)
            by_name[name] = svc
        if "project" in spec:
            svc.project = spec["project"]
        if "platform" in spec:
            svc.platform = spec["platform"]
        if "ssm" in spec:
            svc.ssm_candidates = [spec["ssm"]]
            svc.source = "ssm"
            svc.unresolvable = None
        if "function" in spec:
            svc.fn_name = spec["function"]
            svc.source = spec.get("source", "lambda-image")
            svc.unresolvable = None
        if "ecs_cluster" in spec:
            svc.ecs_clusters = {env: spec["ecs_cluster"] for env in ENVS}
            svc.ecs_service = spec.get("ecs_service", svc.ecs_service or name)
            svc.source = spec.get("source", "ecs-image")
            svc.unresolvable = None
        if "source" in spec:
            svc.source = spec["source"] or None
        if "note" in spec:
            svc.note = spec["note"]
        notes.append(f"override applied to {name}")

    ignores = data.get("ignore") or []
    if ignores:
        before = len(services)
        services[:] = [
            s
            for s in services
            if not any(
                fnmatch.fnmatch(s.name, p) or fnmatch.fnmatch(s.project or "", p)
                for p in ignores
            )
        ]
        if before != len(services):
            notes.append(f"{before - len(services)} service(s) ignored by overrides")
    return notes


def read_maintainers(repo: Path, project: str | None) -> list[str]:
    """
    Squad(s) owning a project, from its own pyproject.toml.

    `[tool.poetry].maintainers` is what this monorepo uses; PEP 621
    `[project].maintainers` is accepted too (its entries are tables, so the
    name is pulled out). Only the project root's file is read — the libs and
    integration_tests under it carry their own, sometimes different, values.

    Falls back to a regex when no TOML parser is available, because unlike the
    poetry.lock closure this one field is simple enough to scrape safely, and
    silently reporting every squad's services would be worse.
    """
    if not project:
        return []
    pp = repo / project / "pyproject.toml"
    if not pp.is_file():
        return []
    text = pp.read_text(encoding="utf-8", errors="replace")
    raw: list = []
    if tomllib is not None:
        try:
            data = tomllib.loads(text)
            raw = (
                data.get("tool", {}).get("poetry", {}).get("maintainers")
                or data.get("project", {}).get("maintainers")
                or []
            )
        except Exception:  # noqa: BLE001 - fall through to the regex
            raw = []
    if not raw:
        m = MAINTAINERS_RE.search(text)
        if m:
            raw = [part.strip().strip("\"'") for part in m.group(1).split(",")]

    out = []
    for entry in raw:
        name = entry.get("name", "") if isinstance(entry, dict) else str(entry)
        name = name.strip()
        if name:
            out.append(name)
    return out


# --------------------------------------------------------------------------- #
# Dependency scope (poetry.lock closure)
# --------------------------------------------------------------------------- #


def compute_scope(repo: Path, project: str) -> tuple[list[str], bool]:
    """
    Repo-relative paths whose changes count as changes to this service:
    its own directory plus every directory-source package in the "main" group of
    its poetry.lock. That lock is the resolved, fully transitive first-party
    closure the build installs, so a change to an unrelated shared lib does not
    show up as affecting a service that never pulls it in.

    Returns (paths, degraded) — degraded means we fell back to own-dir only.
    """
    paths = {project}
    lock = repo / project / "poetry.lock"
    if tomllib is None or not lock.is_file():
        return sorted(paths), True
    try:
        data = tomllib.loads(lock.read_text(encoding="utf-8", errors="replace"))
    except Exception:  # noqa: BLE001 - an unparseable lock degrades, never fails
        return sorted(paths), True
    for pkg in data.get("package", []):
        src = pkg.get("source") or {}
        if src.get("type") != "directory":
            continue
        groups = pkg.get("groups")
        if groups is not None and "main" not in groups:
            continue  # dev-only path dep: not in the artifact
        url = src.get("url") or ""
        paths.add(os.path.normpath(os.path.join(project, url)))
    return sorted(paths), False


# --------------------------------------------------------------------------- #
# Version string parsing
# --------------------------------------------------------------------------- #


@dataclass
class Version:
    raw: str
    sha: str | None = None  # short sha as it appears in the tag
    build: str | None = None  # pipeline IID
    kind: str = "unparsed"  # commit | not-deployed | unparsed
    modified: str | None = None  # ISO timestamp, when the source exposes one


def parse_version(raw: str | None, app_name: str | None = None) -> Version:
    """
    Pull `<short-sha>[-<pipeline-iid>]` out of a deploy version string.

    Real values this has to survive, all from live SSM/AWS:
        st-profiles-bab6eb65-147609.zip
        9eafd244-144130
        0478be3-562                       (7-char sha)
        f3a5367a                          (no pipeline iid)
        content_catalog_service_api:df9d3112
        550127688257.dkr.ecr...:13759b0b-146887
        collection/st/st-reatime-indexer:0.1-4a5a17a-137
        -                                 (never deployed)
        latest / 2026-04-09 / development-1788528941660   (not a commit at all)

    The last group is why this returns a `kind` instead of sed-ing blindly: a
    non-commit tag must be reported as such, not mangled into a fake sha.
    """
    if raw is None:
        return Version(raw="", kind="not-deployed")
    value = raw.strip()
    if value.lower() in NOT_DEPLOYED_VALUES:
        return Version(raw=value, kind="not-deployed")

    tag = value
    if ":" in tag:  # an image URI or repo:tag — only the tag matters
        tag = tag.rsplit(":", 1)[1]
    if tag.endswith(".zip"):
        tag = tag[: -len(".zip")]
    if app_name:  # drop the leading "<app-name>-" a zip name carries
        for prefix in (f"{hy(app_name)}-", f"{app_name}-"):
            if tag.startswith(prefix):
                tag = tag[len(prefix) :]
                break

    tokens = tag.split("-")
    # Prefer a hex token immediately followed by a decimal one: that is exactly
    # the CI's "<short-sha>-<pipeline-iid>" shape and is unambiguous.
    for i, tok in enumerate(tokens):
        if HEX_RE.match(tok) and i + 1 < len(tokens) and DEC_RE.match(tokens[i + 1]):
            return Version(raw=value, sha=tok, build=tokens[i + 1], kind="commit")
    # Otherwise the last hex-shaped token, skipping pure-decimal ones (a bare
    # pipeline iid is decimal and would otherwise pass as a sha).
    for tok in reversed(tokens):
        if HEX_RE.match(tok) and not DEC_RE.match(tok):
            return Version(raw=value, sha=tok, kind="commit")
    return Version(raw=value, kind="unparsed")


# --------------------------------------------------------------------------- #
# AWS readers
# --------------------------------------------------------------------------- #


class Aws:
    def __init__(self, profile_fmt: str, region: str):
        self.profile_fmt = profile_fmt
        self.region = region
        self.auth_failed: dict[str, str] = {}  # profile -> first error line

    def profile(self, env: str) -> str:
        return self.profile_fmt.format(env=env)

    def _cli(self, env: str, args: list[str]) -> tuple[int, str, str]:
        rc, out, err = run(
            ["aws", "--profile", self.profile(env), "--region", self.region, *args]
        )
        if rc != 0 and AUTH_RE.search(err):
            self.auth_failed.setdefault(
                self.profile(env),
                next((ln.strip() for ln in err.splitlines() if AUTH_RE.search(ln)), err),
            )
        return rc, out, err

    # -- SSM ---------------------------------------------------------------- #

    def ssm_batch(self, env: str, names: list[str]) -> dict[str, dict]:
        """
        Read the given parameters by exact name.

        Explicit names, never get-parameters-by-path --recursive: the account
        parameter tree holds API keys, service passwords and KMS blobs next to
        the version parameters, and a version report has no business pulling
        those into memory or onto disk.
        """
        account = ACCOUNT_FMT.format(env=env)
        full = [f"/{account}/{n}" for n in names]
        found: dict[str, dict] = {}
        for i in range(0, len(full), SSM_BATCH):
            chunk = full[i : i + SSM_BATCH]
            rc, out, err = self._cli(
                env, ["ssm", "get-parameters", "--names", *chunk, "--output", "json"]
            )
            if rc != 0:
                if not AUTH_RE.search(err):
                    warn(f"ssm get-parameters failed for {env}: {err.splitlines()[-1] if err else rc}")
                continue
            try:
                payload = json.loads(out)
            except json.JSONDecodeError:
                continue
            for param in payload.get("Parameters", []):
                leaf = param["Name"][len(f"/{account}/") :]
                found[leaf] = {
                    "value": param.get("Value", ""),
                    "modified": param.get("LastModifiedDate"),
                    "revision": param.get("Version"),
                }
        return found

    # -- Lambda ------------------------------------------------------------- #

    def lambda_image(self, env: str, fn: str) -> tuple[str | None, str | None]:
        rc, out, err = self._cli(
            env,
            [
                "lambda",
                "get-function",
                "--function-name",
                fn,
                "--query",
                "{Uri:Code.ImageUri,Mod:Configuration.LastModified}",
                "--output",
                "json",
            ],
        )
        if rc != 0:
            return None, None
        try:
            payload = json.loads(out)
        except json.JSONDecodeError:
            return None, None
        return payload.get("Uri"), payload.get("Mod")

    # -- ECS ---------------------------------------------------------------- #

    def ecs_image(
        self, env: str, cluster: str, service: str, match: str
    ) -> tuple[str | None, str | None]:
        if not cluster or not service:
            return None, None
        rc, out, _ = self._cli(
            env,
            [
                "ecs",
                "describe-services",
                "--cluster",
                cluster,
                "--services",
                service,
                "--query",
                "services[0].taskDefinition",
                "--output",
                "text",
            ],
        )
        if rc != 0 or not out.startswith("arn:"):
            return None, None
        task_def = out
        rc, out, _ = self._cli(
            env,
            [
                "ecs",
                "describe-task-definition",
                "--task-definition",
                task_def,
                "--query",
                "{Images:taskDefinition.containerDefinitions[].image,"
                "Reg:taskDefinition.registeredAt}",
                "--output",
                "json",
            ],
        )
        if rc != 0:
            return None, None
        try:
            payload = json.loads(out)
        except json.JSONDecodeError:
            return None, None
        images = payload.get("Images") or []
        # Skip sidecars (datadog agent, etc.) — take the app's own image.
        own = [img for img in images if match in img] or images
        return (own[0] if own else None), payload.get("Reg")


# --------------------------------------------------------------------------- #
# Collect deployed state
# --------------------------------------------------------------------------- #


@dataclass
class Deployed:
    version: Version
    effective: str | None = None  # full hash of the in-scope commit
    source: str = ""  # where the version came from
    disagreement: str | None = None  # SSM said something else
    unknown_sha: bool = False  # tag parsed, but no such commit in this checkout
    off_trunk: bool = False  # commit is not an ancestor of the trunk branch


def collect(
    aws: Aws, services: list[Service], envs: tuple[str, ...], workers: int
) -> dict[tuple[str, str], Deployed]:
    """
    Read every (service, env) deployed version.

    SSM is fetched for every service that has a candidate path — one batched
    call per chunk per env, so it is nearly free — and then used either as the
    source (v1) or as corroboration (v2 / live-readable). Live reads fan out one
    task per (service, env); they are independent, so wall time is the slowest
    single call rather than the sum.
    """
    results: dict[tuple[str, str], Deployed] = {}

    # One SSM sweep per env over every candidate path.
    ssm_names = sorted({c for s in services for c in s.ssm_candidates})
    ssm: dict[str, dict[str, dict]] = {env: {} for env in envs}
    if ssm_names:
        with cf.ThreadPoolExecutor(max_workers=len(envs)) as pool:
            for env, found in zip(
                envs, pool.map(lambda e: aws.ssm_batch(e, ssm_names), envs)
            ):
                ssm[env] = found

    # Live reads, fanned out.
    jobs: list[tuple[str, str]] = []
    for svc in services:
        if svc.source in ("lambda-image", "ecs-image"):
            jobs.extend((svc.key, env) for env in envs)
    by_key = {s.key: s for s in services}

    def live(job: tuple[str, str]) -> tuple[tuple[str, str], tuple[str | None, str | None]]:
        key, env = job
        svc = by_key[key]
        if svc.source == "lambda-image":
            return job, aws.lambda_image(env, svc.fn_name or svc.name)
        return job, aws.ecs_image(
            env, svc.ecs_clusters.get(env, ""), svc.ecs_service or svc.name, svc.name
        )

    live_out: dict[tuple[str, str], tuple[str | None, str | None]] = {}
    if jobs:
        with cf.ThreadPoolExecutor(max_workers=max(1, workers)) as pool:
            for job, out in pool.map(live, jobs):
                live_out[job] = out

    for svc in services:
        for env in envs:
            ssm_hit = next(
                (
                    ssm[env][c]
                    for c in svc.ssm_candidates
                    if c in ssm[env] and ssm[env][c].get("value")
                ),
                None,
            )
            ssm_ver = (
                parse_version(ssm_hit["value"], svc.name) if ssm_hit else None
            )
            if ssm_ver and ssm_hit:
                ssm_ver.modified = ssm_hit.get("modified")

            if svc.source == "ssm":
                dep = Deployed(
                    version=ssm_ver or Version(raw="", kind="not-deployed"),
                    source="ssm",
                )
            elif svc.source in ("lambda-image", "ecs-image"):
                raw, modified = live_out.get((svc.key, env), (None, None))
                ver = parse_version(raw, svc.name)
                ver.modified = modified
                dep = Deployed(version=ver, source=svc.source)
                # A stale v1 parameter left behind by the v2 migration shows up
                # here. Worth naming, but the live resource is the truth.
                if ssm_ver and ssm_ver.sha and ver.sha and ssm_ver.sha != ver.sha:
                    dep.disagreement = f"SSM says {ssm_ver.sha}"
            else:
                dep = Deployed(
                    version=Version(raw="", kind="unparsed"), source="none"
                )
            results[(svc.key, env)] = dep
    return results


def resolve_commits(
    git: Git,
    services: list[Service],
    state: dict[tuple[str, str], Deployed],
    envs: tuple[str, ...],
    trunk: str | None,
    trunk_label: str = "the trunk",
) -> tuple[list[str], list[str], set[str]]:
    """
    Map every parsed sha to the newest in-scope commit at-or-before it.

    Returns (findings, detail, unfound shas):
      findings — something a human should act on (a branch deploy, say)
      detail   — explains a value the table already shows; -v only, because at
                 fleet scale one line per service/env buries the findings
      unfound  — the caller widens the fetch and retries when this is non-empty:
                 a deploy made from a feature branch is not reachable from the
                 trunk branch alone.
    """
    findings: list[str] = []  # always shown: something is off
    detail: list[str] = []  # -v only: explains a value the table already shows
    rebased: dict[tuple[str, str, str], list[str]] = {}
    missing: set[str] = set()
    for svc in services:
        for env in envs:
            dep = state[(svc.key, env)]
            dep.unknown_sha = False
            if dep.version.kind != "commit" or not dep.version.sha:
                continue
            full = git.resolve(dep.version.sha)
            if not full:
                missing.add(dep.version.sha)
                dep.unknown_sha = True
                continue
            dep.effective = git.newest_touching(full, svc.scope) or full
            dep.off_trunk = bool(trunk) and not git.is_ancestor(full, trunk)
            if dep.effective[: len(dep.version.sha)] != dep.version.sha:
                # Same artifact keeps landing in several envs; one line per
                # (service, artifact) instead of one per environment.
                rebased.setdefault(
                    (svc.key, dep.version.sha, dep.effective), []
                ).append(env)
            if dep.off_trunk:
                meta = git.show(full)
                findings.append(
                    f"{svc.key}/{env} runs {dep.version.sha} "
                    f"(\"{meta['subject'][:44]}\", {meta['author']}) which is NOT on "
                    f"{trunk_label} — deployed from a branch"
                )

    for (key, raw, eff), where in rebased.items():
        detail.append(
            f"{key} [{','.join(where)}]: artifact {raw} changed nothing inside this "
            f"service's closure — showing {eff[:8]}, the newest commit it contains "
            f"that did"
        )
    return findings, detail, missing


# --------------------------------------------------------------------------- #
# Rendering
# --------------------------------------------------------------------------- #


def age(iso: str | None) -> str:
    """Compact "how long has this env been on this version"."""
    if not iso:
        return ""
    text = iso.replace("Z", "+00:00")
    try:
        when = datetime.fromisoformat(text)
    except ValueError:
        return ""
    if when.tzinfo is None:
        when = when.replace(tzinfo=timezone.utc)
    delta = datetime.now(timezone.utc) - when
    hours = delta.total_seconds() / 3600
    if hours < 1:
        return f"{int(delta.total_seconds() // 60)}m"
    if hours < 48:
        return f"{int(hours)}h"
    return f"{int(hours // 24)}d"


def clip(text: str, width: int) -> str:
    return text if len(text) <= width else text[: width - 3] + "..."


def cell(dep: Deployed) -> str:
    if dep.source == "none":
        return "—"
    v = dep.version
    if v.kind == "not-deployed":
        return "not deployed"
    if v.kind == "unparsed":
        return clip(f"?{v.raw}", 18)
    sha = (dep.effective[:8] if dep.effective else v.sha) or "?"
    mark = "?" if dep.unknown_sha else ("!" if dep.off_trunk else "")
    a = age(v.modified)
    return f"{sha}{mark}{('  ' + a) if a else ''}"


def render_matrix(
    services: list[Service],
    state: dict[tuple[str, str], Deployed],
    git: Git,
    envs: tuple[str, ...],
) -> None:
    name_w = max([28] + [len(s.key) for s in services]) + 2
    env_w = 21
    show_drift = len(envs) > 1
    head = f"{'SERVICE':<{name_w}}" + "".join(f"{e.upper():<{env_w}}" for e in envs)
    rule = f"{'-' * (name_w - 2):<{name_w}}" + "".join(
        f"{'-' * (env_w - 2):<{env_w}}" for _ in envs
    )
    if show_drift:
        head += "DRIFT"
        rule += "-" * 18
    print(f"{C.BOLD}{head.rstrip()}{C.OFF}")
    print(rule.rstrip())

    colors = {"dev": C.BLUE, "stg": C.ORANGE, "prod": C.RED}
    for svc in services:
        row = f"{svc.key:<{name_w}}"
        prev_color = C.BLUE
        prev_sha = None
        for env in envs:
            dep = state[(svc.key, env)]
            sha = dep.effective
            if prev_sha is None or sha == prev_sha:
                color = prev_color
            else:
                color = colors.get(env, C.RED)
            row += f"{color}{cell(dep):<{env_w}}{C.OFF}"
            prev_color, prev_sha = color, sha

        if not show_drift:
            print(row.rstrip())
            continue

        # Drift: how many in-scope commits each env is behind the first env.
        head_env = envs[0]
        head_sha = state[(svc.key, head_env)].effective
        parts = []
        for env in envs[1:]:
            sha = state[(svc.key, env)].effective
            if not head_sha or not sha:
                continue
            if sha == head_sha:
                continue
            if git.is_ancestor(sha, head_sha):
                n = git.count_between(sha, head_sha, svc.scope)
                parts.append(f"{env} -{n}")
            elif git.is_ancestor(head_sha, sha):
                n = git.count_between(head_sha, sha, svc.scope)
                parts.append(f"{C.RED}{env} +{n}{C.OFF}")  # ahead of dev: unexpected
            else:
                parts.append(f"{env} diverged")
        resolved = sum(1 for e in envs if state[(svc.key, e)].effective)
        if parts:
            row += " · ".join(parts)
        elif resolved > 1:
            row += f"{C.GREY}in sync{C.OFF}"
        elif resolved == 1:
            row += f"{C.GREY}only one env resolved{C.OFF}"
        print(row)

    flags = []
    if any(state[(s.key, e)].unknown_sha for s in services for e in envs):
        flags.append("? = tag parsed but that commit is not in this checkout")
    if any(state[(s.key, e)].off_trunk for s in services for e in envs):
        flags.append("! = deployed from a branch, not merged into the trunk")
    if flags:
        print()
        for line in flags:
            print(f"{C.GREY}{line}{C.OFF}")

    unresolved = [s for s in services if s.source is None]
    if unresolved:
        print()
        print(f"{C.GREY}Not resolvable from AWS ({len(unresolved)}):{C.OFF}")
        for svc in unresolved:
            print(f"{C.GREY}  {svc.key:<38} {svc.unresolvable}{C.OFF}")


# Log-table column widths. ARTIFACT carries "<short-sha>-<pipeline-iid>" —
# the deployed zip/image version — and is filled only on rows an environment
# actually sits on.
COL_COMMIT, COL_DATE, COL_MSG, COL_AUTHOR, COL_ARTIFACT = 11, 12, 45, 15, 18
TABLE_W = COL_COMMIT + COL_DATE + COL_MSG + COL_AUTHOR + COL_ARTIFACT + 4 + 8


def artifact_label(dep: Deployed) -> str:
    """The deployed version as the CI wrote it: <short-sha>-<pipeline-iid>."""
    v = dep.version
    if v.kind != "commit" or not v.sha:
        return ""
    return f"{v.sha}-{v.build}" if v.build else v.sha


def render_log(
    services: list[Service],
    state: dict[tuple[str, str], Deployed],
    git: Git,
    envs: tuple[str, ...],
    pending: bool,
    branch: str,
) -> list[str]:
    extra_notes: list[str] = []
    for svc in services:
        deployed = {env: state[(svc.key, env)].effective for env in envs}
        live = [c for c in deployed.values() if c]
        subtitle = f"{svc.project or '?'} · {svc.platform} · {svc.generation}"
        print()
        print(f"{C.BOLD}{svc.key}{C.OFF}   {C.GREY}{subtitle}{C.OFF}")
        print("─" * TABLE_W)
        if not live:
            reason = svc.unresolvable or "no deployed commit could be resolved"
            print(f"{C.GREY}  {reason}{C.OFF}")
            continue

        # One line of "how far apart are these environments", scoped to this
        # service's own code, so the table below has a headline.
        head_env = envs[0]
        gaps = []
        for env in envs[1:]:
            a, b = deployed.get(env), deployed.get(head_env)
            if not a or not b or a == b:
                continue
            if git.is_ancestor(a, b):
                gaps.append(f"{env} is {git.count_between(a, b, svc.scope)} behind {head_env}")
            elif git.is_ancestor(b, a):
                gaps.append(f"{env} is {git.count_between(b, a, svc.scope)} AHEAD of {head_env}")
            else:
                gaps.append(f"{env} has diverged from {head_env}")
        print(f"{C.GREY}  {'; '.join(gaps) if gaps else 'all environments in sync'}{C.OFF}")
        print(
            f"{'COMMIT':<{COL_COMMIT}} {'DATE':<{COL_DATE}} {'MESSAGE':<{COL_MSG}} "
            f"{'AUTHOR':<{COL_AUTHOR}} {'ARTIFACT':<{COL_ARTIFACT}} PINNED"
        )
        print(
            f"{'-' * COL_COMMIT} {'-' * COL_DATE} {'-' * COL_MSG} "
            f"{'-' * COL_AUTHOR} {'-' * COL_ARTIFACT} {'-' * 8}"
        )

        oldest, newest = git.oldest(live), git.newest(live)
        chain = [newest] + git.commits_between(oldest, newest, svc.scope)
        # Keep the exact order git gave us (newest first) and make sure the
        # oldest deployed commit is present even if it is off the first-parent
        # chain of the newest.
        chain = list(dict.fromkeys(chain + [oldest]))

        if pending:
            tip = git.resolve(f"origin/{branch}") or git.resolve(branch)
            if tip and tip != newest:
                ahead = git.commits_between(newest, tip, svc.scope)
                chain = ahead + chain

        for full in chain:
            meta = git.show(full)
            here = [e for e in envs if deployed.get(e) == full]
            pins = [e.upper() for e in here]
            pin = ""
            if pins:
                color = C.RED if "PROD" in pins else (C.ORANGE if "STG" in pins else C.BLUE)
                pin = f"{color}◄ {','.join(pins)}{C.OFF}"
            elif pending and not any(
                git.is_ancestor(full, c) or full == c for c in live
            ):
                pin = f"{C.GREY}(not deployed){C.OFF}"

            # Environments sharing a commit normally share the artifact too
            # (prod is promoted from the same build). When they do not — a
            # rebuild of the same commit — show the first and flag it, rather
            # than widening the column for a rare case.
            labels = [artifact_label(state[(svc.key, e)]) for e in here]
            distinct = list(dict.fromkeys(l for l in labels if l))
            artifact = distinct[0] if distinct else ""
            if len(distinct) > 1:
                artifact += "*"
                extra_notes.append(
                    f"{svc.key}: {', '.join(pins)} all run commit {full[:8]} but from "
                    f"different artifacts ({' vs '.join(distinct)})"
                )
            print(
                f"{full[:8]:<{COL_COMMIT}} {meta['date']:<{COL_DATE}} "
                f"{clip(meta['subject'], COL_MSG):<{COL_MSG}} "
                f"{clip(meta['author'], COL_AUTHOR):<{COL_AUTHOR}} "
                f"{artifact:<{COL_ARTIFACT}} {pin}".rstrip()
            )

        for env in envs:
            dep = state[(svc.key, env)]
            if dep.disagreement:
                extra_notes.append(
                    f"{svc.key}/{env}: live image is {dep.version.sha}, "
                    f"{dep.disagreement} — the SSM parameter is stale"
                )
    return extra_notes


def render_json(
    services: list[Service],
    state: dict[tuple[str, str], Deployed],
    git: Git,
    envs: tuple[str, ...],
) -> None:
    out = []
    for svc in services:
        entry = {
            "key": svc.key,
            "name": svc.name,
            "project": svc.project,
            "platform": svc.platform,
            "generation": svc.generation,
            "maintainers": svc.maintainers,
            "source": svc.source,
            "unresolvable": svc.unresolvable,
            "scope": svc.scope,
            "scope_degraded": svc.scope_degraded,
            "environments": {},
        }
        for env in envs:
            dep = state[(svc.key, env)]
            meta = git.show(dep.effective) if dep.effective else {}
            entry["environments"][env] = {
                "raw": dep.version.raw,
                "kind": dep.version.kind,
                "sha": dep.version.sha,
                "build": dep.version.build,
                "source": dep.source,
                "modified": dep.version.modified,
                "effective_commit": dep.effective,
                "commit_date": meta.get("date"),
                "commit_author": meta.get("author"),
                "commit_subject": meta.get("subject"),
                "disagreement": dep.disagreement,
                "unknown_sha": dep.unknown_sha,
                "off_trunk": dep.off_trunk,
            }
        out.append(entry)
    json.dump(out, sys.stdout, indent=2)
    print()


# --------------------------------------------------------------------------- #
# Main
# --------------------------------------------------------------------------- #


def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(
        prog="deploy_diff.py",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description="Which commit of each smart-topics service is live in dev/stg/prod.",
        epilog=f"""\
views
  no --service       drift matrix: one row per service, one column per env
  with --service     per-service commit log with ARTIFACT and ◄ ENV pins
  --log / --matrix   force either view regardless of --service
  --json             machine-readable dump of everything

scope
  With no --service, only services whose pyproject.toml declares
  maintainers = ["{DEFAULT_MAINTAINER}"] are reported. --maintainer NAME picks a
  different squad, --maintainer all reports every service, and an explicit
  --service overrides the filter entirely.

examples
  deploy_diff.py                        # the squad's services, drift matrix
  deploy_diff.py --log                  # the squad's services, commit log
  deploy_diff.py --service st-profiles  # one service, commit log (implied)
  deploy_diff.py --service 'st-sub*' --matrix
  deploy_diff.py --maintainer all       # every deployable project (~60)
  deploy_diff.py --pending --service internal-users-service
  deploy_diff.py --list                 # catalogue only, no AWS calls
  deploy_diff.py --json | jq '.[] | select(.environments.prod.sha == null)'

credentials
  Reads with the read-only profiles smart-topics-<env>-nvirginia. Refresh
  them with `dev login`, or `aws sso login --profile <profile>` per account.
""",
    )
    p.add_argument("--repo", type=Path, default=Path(os.environ.get("DEPLOY_DIFF_REPO", DEFAULT_REPO)),
                   help=f"backend monorepo checkout (default: {DEFAULT_REPO})")
    p.add_argument("--service", default="",
                   help="comma-separated names or globs; matched against the service "
                        "name and its project path (default: all)")
    p.add_argument("--maintainer", default=os.environ.get("DEPLOY_DIFF_MAINTAINER", DEFAULT_MAINTAINER),
                   help=f"squad from pyproject.toml [tool.poetry].maintainers "
                        f"(default: {DEFAULT_MAINTAINER}; use 'all' for every service). "
                        f"Ignored when --service is given.")
    p.add_argument("--env", default=",".join(ENVS),
                   help=f"comma-separated environments (default: {','.join(ENVS)})")
    p.add_argument("--log", action="store_true",
                   help="force the per-service commit log view (default when --service is given)")
    p.add_argument("--matrix", action="store_true",
                   help="force the drift matrix (default when --service is omitted)")
    p.add_argument("--json", action="store_true", help="JSON output")
    p.add_argument("--list", action="store_true",
                   help="print the discovered catalogue and exit (no AWS calls)")
    p.add_argument("--pending", action="store_true",
                   help="in --log, also show in-scope commits merged but not yet in the "
                        "first environment")
    p.add_argument("--overrides", type=Path,
                   default=(Path(_env_overrides) if (_env_overrides := os.environ.get(
                       "DEPLOY_DIFF_OVERRIDES", "").strip()) else None),
                   help="overrides JSON (default: overrides.json next to this script)")
    p.add_argument("--profile-fmt", default=os.environ.get("DEPLOY_DIFF_PROFILE_FMT", PROFILE_FMT),
                   help=f"AWS profile template, {{env}} substituted (default: {PROFILE_FMT})")
    p.add_argument("--branch", default=DEFAULT_BRANCH, help=f"trunk branch (default: {DEFAULT_BRANCH})")
    p.add_argument("--no-fetch", action="store_true", help="skip `git fetch` of the trunk branch")
    p.add_argument("--no-color", action="store_true", help="disable ANSI color")
    p.add_argument("--workers", type=int, default=16, help="max concurrent AWS calls (default: 16)")
    p.add_argument("-v", "--verbose", action="store_true", help="show discovery and scope notes")
    return p


def by_maintainer(services: list[Service], maintainer: str) -> list[Service]:
    """Services owned by `maintainer` (case-insensitive); 'all' disables it."""
    if maintainer.lower() in ("all", "*", ""):
        return services
    want = maintainer.lower()
    return [s for s in services if any(m.lower() == want for m in s.maintainers)]


def selected(services: list[Service], patterns: str) -> list[Service]:
    if not patterns.strip():
        return services
    pats = [p.strip() for p in patterns.split(",") if p.strip()]
    out = []
    for svc in services:
        haystack = [svc.key, svc.name, svc.project or ""]
        if svc.project:
            haystack.append(Path(svc.project).name)
        if any(
            fnmatch.fnmatch(h, p) or p == h or (p in h and "*" not in p)
            for p in pats
            for h in haystack
        ):
            out.append(svc)
    return out


def print_auth_guidance(aws: Aws) -> None:
    error("AWS credentials are expired or missing — deployed state could not be read.")
    for profile, detail in aws.auth_failed.items():
        error(f"  {profile}: {detail}")
    error("Refresh your session, then re-run:")
    if shutil.which("dev"):
        error("    dev login        # refreshes every smart-topics profile at once")
    for profile in aws.auth_failed:
        error(f"    aws sso login --profile {profile}")


def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)

    if args.no_color or not sys.stdout.isatty():
        C.disable()

    repo = args.repo.expanduser()
    rc, root, _ = run(["git", "-C", str(repo), "rev-parse", "--show-toplevel"])
    if rc != 0:
        error(f"{repo} is not a git repository — pass --repo <backend monorepo>.")
        return 1
    git = Git(Path(root))

    envs = tuple(e.strip() for e in args.env.split(",") if e.strip())
    unknown = [e for e in envs if e not in ENVS]
    if unknown:
        error(f"Unknown environment(s): {', '.join(unknown)}. Valid: {', '.join(ENVS)}")
        return 1

    head_branch = git("rev-parse", "--abbrev-ref", "HEAD") or "detached"
    if head_branch != args.branch:
        info(
            f"Catalogue read from the working tree at {head_branch} "
            f"({git('rev-parse', '--short', 'HEAD')}) — a branch that changes a "
            f".git_config.yml changes which source this reports from."
        )

    services, notes = discover(git)
    if not services:
        return 1
    overrides = args.overrides or (Path(__file__).resolve().parent.parent / "overrides.json")
    notes += apply_overrides(services, overrides)
    services.sort(key=lambda s: (s.name, s.project or ""))
    notes += assign_keys(services)

    # A duplicate application_name or SSM path can misattribute a deploy, so
    # those surface unconditionally; everything else is -v chatter.
    for note in notes:
        if "claimed by both" in note or "declared by more than one" in note:
            warn(note)
        elif args.verbose:
            info(note)

    for svc in services:
        svc.maintainers = read_maintainers(git.root, svc.project)

    # An explicit --service is a deliberate choice and outranks the squad
    # default; otherwise narrow to the squad so a bare run is useful.
    total = len(services)
    if args.service.strip():
        services = selected(services, args.service)
        if not services:
            error(f"No service matched {args.service!r}. Try --list.")
            return 1
    else:
        services = by_maintainer(services, args.maintainer)
        if not services:
            error(
                f"No service has maintainers = [\"{args.maintainer}\"] in its "
                f"pyproject.toml. Use --maintainer all, or --service <name>."
            )
            return 1
        if len(services) != total:
            # Never narrow silently: say what was dropped and how to undo it.
            info(
                f"Showing the {len(services)} service(s) maintained by "
                f"'{args.maintainer}' of {total} in the monorepo "
                f"(--maintainer all for every service)."
            )

    for svc in services:
        if svc.project:
            svc.scope, svc.scope_degraded = compute_scope(git.root, svc.project)
        else:
            svc.scope = []

    # Scope drives every number in the report, so a degraded scope is a
    # correctness caveat, not a detail: it makes drift counts and log tables
    # narrower than reality. Always say it.
    if tomllib is None:
        warn(
            f"No TOML parser available on {sys.executable} (needs python 3.11+, or "
            f"`pip install tomli`) — every service is scoped to its own directory "
            f"only, so drift counts and log tables will UNDERSTATE reality."
        )
    else:
        degraded = [s for s in services if s.scope_degraded]
        if degraded:
            warn(
                f"{len(degraded)} service(s) have no readable poetry.lock and are "
                f"scoped to their own directory only "
                f"({', '.join(s.key for s in degraded[:4])}"
                f"{', ...' if len(degraded) > 4 else ''}) — their drift counts "
                f"understate changes coming from shared libs."
            )

    if args.list:
        print(
            f"{'SERVICE':<40} {'GEN':<8} {'PLATFORM':<14} {'MAINTAINERS':<22} "
            f"{'SOURCE':<13} DETAIL"
        )
        print(
            "-" * 40 + " " + "-" * 8 + " " + "-" * 14 + " " + "-" * 22 + " "
            + "-" * 13 + " " + "-" * 40
        )
        for svc in services:
            detail = svc.unresolvable or (
                svc.ssm_candidates[0] if svc.ssm_candidates else (svc.project or "")
            )
            print(
                f"{svc.key:<40} {svc.generation:<8} {svc.platform:<14} "
                f"{clip(','.join(svc.maintainers) or '-', 22):<22} "
                f"{(svc.source or 'none'):<13} {clip(detail, 60)}"
            )
        return 0

    if not shutil.which("aws"):
        error("AWS CLI not found — install it or use --list.")
        return 1

    if not args.no_fetch:
        info(f"Fetching origin/{args.branch} ...")
        rc, _, err = run(["git", "-C", str(git.root), "fetch", "origin", args.branch])
        if rc != 0:
            warn(f"Could not fetch origin/{args.branch} — results may be incomplete ({err.splitlines()[-1] if err else rc})")

    aws = Aws(args.profile_fmt, REGION)
    info(
        f"Reading {len(services)} service(s) across {', '.join(envs)} "
        f"(profiles {', '.join(aws.profile(e) for e in envs)})"
    )
    state = collect(aws, services, envs, args.workers)

    if aws.auth_failed:
        print_auth_guidance(aws)
        if not any(
            state[(s.key, e)].version.kind == "commit" for s in services for e in envs
        ):
            return 1
        info("Continuing with whatever did answer.")

    trunk = git.resolve(f"origin/{args.branch}") or git.resolve(args.branch)
    findings, detail, missing = resolve_commits(
        git, services, state, envs, trunk, f"origin/{args.branch}"
    )
    if missing and not args.no_fetch:
        # A deploy made from a feature branch is not reachable from the trunk
        # branch, so the cheap `fetch origin <branch>` above cannot see it. Only
        # now is the full ref fetch worth its cost.
        info(
            f"{len(missing)} deployed sha(s) not on origin/{args.branch} "
            f"— fetching all branches..."
        )
        run(["git", "-C", str(git.root), "fetch", "origin"])
        git._commit_cache.clear()
        findings, detail, missing = resolve_commits(
            git, services, state, envs, trunk, f"origin/{args.branch}"
        )
    if missing:
        findings.append(
            f"{len(missing)} deployed sha(s) still not in this checkout "
            f"({', '.join(sorted(missing)[:5])}) — the artifact may predate a "
            f"history rewrite, or its branch is gone"
        )

    if args.json:
        render_json(services, state, git, envs)
        return 0

    # Naming a service is a request for that service's story, so it gets the
    # commit log; a bare run is a fleet scan, so it gets the matrix. Either
    # flag overrides the guess.
    if args.matrix:
        want_log = False
    elif args.log:
        want_log = True
    else:
        want_log = bool(args.service.strip())

    if want_log:
        findings += render_log(services, state, git, envs, args.pending, args.branch)
    else:
        print()
        render_matrix(services, state, git, envs)

    notes = findings + (detail if args.verbose else [])
    if notes:
        print()
        print(f"{C.BOLD}NOTES{C.OFF}")
        for note in notes:
            print(f"  · {note}")
    if detail and not args.verbose:
        print(
            f"{C.GREY}  · {len(detail)} service(s) show a commit different from their "
            f"artifact tag (monorepo build); re-run with -v for the details.{C.OFF}"
        )
    return 0


if __name__ == "__main__":
    sys.exit(main())
