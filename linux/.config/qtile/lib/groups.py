from libqtile.config import Group, Match

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


groups = [_create_group(i) for i in range(len(_names))]
