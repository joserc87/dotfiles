from libqtile.config import Group, Match, ScratchPad, DropDown

_matches = {
    3: ["Brave-browser"],
    4: ["Chromium"],
    6: ["Slack"],
    7: ["Firefox"],
    9: ["Ferdi"],
    10: ["Spotify"],
}
_spawn = {
    3: ["brave"],
    4: ["chromium"],
    6: ["slack"],
    7: ["firefox"],
    9: ["ferdium"],
    10: ["spotify", "blueman-manager", "pavucontrol"],
}
_layout_opts = {
    10: dict(
        ratio=0.7
    )
}
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
_labels = "#"

_terminal_windows = [0, 1, 2, 5, 8]


def _create_group(i):
    name = _names[i]
    label = _labels[i]
    matches = [Match(wm_class=_matches[i])] if i in _matches else None
    spawn = _spawn[i] if i in _spawn else None
    init = True
    layout = "GapsBig" if i in _terminal_windows else "GapsSmall"
    if i == 10:
        layout = "MainSatelite"
    layout_opts = _layout_opts[i] if i in _layout_opts else None
    return Group(name, label=label, matches=matches, spawn=spawn, init=init, layout=layout, layout_opts=layout_opts)


def create_dropdown(name, cmd):
    return DropDown(
        name, cmd, on_focus_lost_hide=True, x=0.25, y=0.25, width=0.5, height=0.5,
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

_scratchpad = ScratchPad("scratchpad", [
    create_dropdown("task", _taskwarrior_cmd),
    create_dropdown("diary", _vimwiki_cmd),
])

groups = [_create_group(i) for i in range(len(_names))] + [_scratchpad]
