from libqtile.config import Group, Match, ScratchPad, DropDown

_matches = {
    3: ["Brave-browser"],
    4: ["Chromium"],
    6: ["Slack"],
    7: ["Firefox"],
    9: ["Station"],
    10: ["Spotify"],
}
_spawn = {
    3: ["brave"],
    4: ["chromium"],
    6: ["slack"],
    7: ["firefox"],
    9: ["station"],
    # 10: ["spotify"],
}
_names = "#"

_terminal_windows = [0, 1, 2, 5, 8, 10]


def _create_group(i):
    name = _names[i]
    matches = [Match(wm_class=_matches[i])] if i in _matches else None
    spawn = _spawn[i] if i in _spawn else None
    init = True
    layout = "GapsBig" if i in _terminal_windows else "GapsSmall"
    return Group(name, matches=matches, spawn=spawn, init=init, layout=layout)


def create_dropdown(name, cmd):
    return DropDown(
        name, cmd, on_focus_lost_hide=True, x=0.25, y=0.25, width=0.5, height=0.5,
    )

def _alacritty_run(cmd):
    return f"""alacritty \
        --class float \
        -o font.size=16 \
        -o background_opacity=0.8 \
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
