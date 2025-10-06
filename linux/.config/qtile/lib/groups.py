import os
import re

from libqtile.config import DropDown, Group, Match, ScratchPad


def is_work_laptop():
    hostname = os.uname()[1]
    return hostname == "jcano-rplaptop"


WM_CLASS_DEPLOYMENT_TOOL = "deployment-tool.devtools.ravenpack.com__deployments"
WM_CLASS_MEET = "meet.google.com__landing"
WM_CLASS_GMAIL = "mail.google.com__mail_u_0"
WM_CLASS_CALENDAR = "calendar.google.com__calendar_u_0_r"
WM_CLASS_YOUTUBE = "www.youtube.com"

_matches = {
    0: [Match(wm_class="obsidian")],
    2: [Match(wm_class="Xephyr"), Match(wm_class=WM_CLASS_DEPLOYMENT_TOOL)],
    3: [Match(wm_class="zen-alpha")],
    4: [Match(wm_class="Chromium")],
    5: [Match(wm_class="brave-browser")],
    6: [Match(wm_class="Slack")],
    7: [Match(wm_class="Firefox")],
    8: [Match(wm_class=WM_CLASS_MEET)],
    9: [Match(wm_class=WM_CLASS_GMAIL), Match(wm_class=WM_CLASS_CALENDAR)],
    10: [
        Match(wm_class=re.compile(r"^(Spotify|pavucontrol)$")),
        Match(wm_class=WM_CLASS_YOUTUBE),
    ],
}
_spawn_work = {
    0: ["alacritty -e mux all"],
    3: ["zen-browser-optimized"],
    # 4: ["chromium"],
    6: ["slack"],
    7: ["firefox"],
    # 9: ["ferdium"],
    # Disabled: "blueman-manager", "pavucontrol"
    # 10: ["spotify"],
}
_spawn_personal = {
    0: [],
    3: ["zen-browser"],
    4: [],
    6: [],
    7: [],
    9: ["ferdium"],
    # Disabled: "blueman-manager", "pavucontrol"
    10: ["spotify"],
}
_spawn = _spawn_work if is_work_laptop() else _spawn_personal
_layout_opts = {10: dict(ratio=0.7)}
_names = {
    0: "jack",
    1: "term",
    2: "test",
    3: "browser",
    4: "chrome",
    5: "sql",
    6: "slack",
    7: "jira",
    8: "pcmanfm",
    9: "email",
    10: "spotify",
}
_labels = "#󰒱󰌃󰊫"


_terminal_windows = [0, 1, 2, 5, 8]


def _create_group(i):
    name = _names[i]
    label = _labels[i]
    matches = _matches.get(i)
    spawn = _spawn[i] if i in _spawn else None
    init = True
    layout = "GapsBig" if i in _terminal_windows else "GapsSmall"
    if i == 10:
        layout = "MainSatelite"
    layout_opts = _layout_opts[i] if i in _layout_opts else None
    return Group(
        name,
        label=label,
        matches=matches,
        spawn=spawn,
        init=init,
        layout=layout,
        layout_opts=layout_opts,
    )


def create_dropdown(name, cmd):
    return DropDown(
        name,
        cmd,
        on_focus_lost_hide=True,
        x=0.25,
        y=0.25,
        width=0.5,
        height=0.5,
    )


def _alacritty_run(cmd):
    return f"""alacritty \
        --class float \
        -o font.size=16 \
        -o window.padding.x=16 \
        -o window.padding.y=16 \
        -o window.opacity=0.8 \
        -t 'scratchpad' \
        -e sh -c "sleep 0.1 && {cmd}" \
        """  # -r small"""


_taskwarrior_cmd = _alacritty_run("taskwarrior-tui")
_vimwiki_cmd = _alacritty_run("nvim -c VimwikiMakeDiaryNote")
_obsidian_cmd = "obsidian"

_scratchpad = ScratchPad(
    "scratchpad",
    [
        create_dropdown("task", _taskwarrior_cmd),
        create_dropdown("diary", _obsidian_cmd),
    ],
)

groups = [_create_group(i) for i in range(len(_names))] + [_scratchpad]
