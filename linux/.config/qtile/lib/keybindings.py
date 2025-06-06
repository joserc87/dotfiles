from libqtile.config import Key
from libqtile.lazy import lazy

from lib.groups import groups
from lib.keys import (
    ALT,
    BACKSPACE,
    COMMA,
    CTRL,
    DELETE,
    ESCAPE,
    GRAVE,
    PRINT,
    RETURN,
    SEMICOLON,
    SHIFT,
    SPACE,
    TAB,
    UNDERSCORE,
)
from lib.settings import APP_LAUNCHER, DEFAULT_TERMINAL, MODKEY
from lib.utils import (
    decrease_gaps,
    exe,
    go_to_group_or_switch_screen,
    go_to_next_screen,
    increase_gaps,
    kick_to_next_screen,
    next_layout,
    term_exe,
)

# Keybindings
keys = [
    # General
    Key([MODKEY, SHIFT], "r", lazy.restart()),
    Key([MODKEY], RETURN, exe(DEFAULT_TERMINAL)),
    Key([MODKEY], BACKSPACE, exe(DEFAULT_TERMINAL)),
    Key([MODKEY], "e", exe("dmenu_run")),
    Key([MODKEY], "z", exe("morc_menu")),
    Key([MODKEY, SHIFT], "q", lazy.window.kill()),
    Key([MODKEY, CTRL], "q", lazy.window.kill()),
    Key([MODKEY], "F5", term_exe("mocp")),
    Key([MODKEY], DELETE, exe("logoff")),
    Key([MODKEY, SHIFT], "c", exe("compton-toggle")),
    Key([MODKEY, SHIFT], "e", exe("sgtk-bar")),
    # Key([MODKEY, SHIFT], ESCAPE, lazy.shutdown()),
    # TODO: Add Screenshots like i3-scrot
    Key([MODKEY], PRINT, lazy.spawn(["scrot", "-s"])),
    Key([MODKEY, SHIFT], "4", lazy.spawn(["flameshot", "gui"])),
    Key([MODKEY], "4", lazy.spawn(["flameshot", "screen"])),
    # Move Focus
    Key([ALT], TAB, lazy.layout.next()),
    Key([ALT, SHIFT], TAB, lazy.layout.previous()),
    Key([MODKEY], "h", lazy.layout.left()),
    Key([MODKEY], "j", lazy.layout.down()),
    Key([MODKEY], "k", lazy.layout.up()),
    Key([MODKEY], "l", lazy.layout.right()),
    # Key([MODKEY, SHIFT], SPACE, lazy.layout.flip()),
    # Move Window
    Key([MODKEY, SHIFT], "j", lazy.layout.shuffle_down()),
    Key([MODKEY, SHIFT], "k", lazy.layout.shuffle_up()),
    Key([MODKEY, SHIFT], "h", lazy.layout.shuffle_left()),
    Key([MODKEY, SHIFT], "l", lazy.layout.shuffle_right()),
    Key([MODKEY, CTRL], "j", lazy.layout.shuffle_down()),
    Key([MODKEY, CTRL], "k", lazy.layout.shuffle_up()),
    Key([MODKEY, CTRL], "h", lazy.layout.shuffle_left()),
    Key([MODKEY, CTRL], "l", lazy.layout.shuffle_right()),
    Key([MODKEY], COMMA, lazy.layout.swap_main()),
    # Alter Window Size
    Key([MODKEY], "minus", lazy.layout.shrink()),
    Key([MODKEY], "equal", lazy.layout.grow()),
    Key([MODKEY, SHIFT], "equal", lazy.layout.reset()),
    Key([MODKEY, CTRL], "equal", lazy.layout.reset()),
    Key([MODKEY], "m", lazy.layout.maximize()),
    Key([MODKEY], "n", lazy.layout.normalize()),
    # Layout
    Key([MODKEY, CTRL], SPACE, lazy.window.toggle_floating()),
    Key([MODKEY, CTRL], UNDERSCORE, lazy.window.toggle_minimize()),
    Key([MODKEY, SHIFT], SPACE, exe("switchkblayout")),
    Key([MODKEY], SPACE, next_layout()),
    Key([MODKEY], "r", lazy.window.toggle_fullscreen()),
    # Screens
    # Key([MODKEY], 'i', lazy.function(go_to_next_screen, -1)),
    # Key([MODKEY], 'o', lazy.function(go_to_next_screen)),
    Key([MODKEY], "q", increase_gaps()),
    Key([MODKEY], "w", decrease_gaps()),
    Key([MODKEY], SEMICOLON, lazy.function(go_to_next_screen)),
    Key([MODKEY], "x", lazy.to_screen(0)),
    Key([MODKEY], "c", lazy.to_screen(1)),
    Key([MODKEY], "v", lazy.to_screen(2)),
    Key([MODKEY, CTRL], "h", lazy.function(kick_to_next_screen, -1)),
    Key([MODKEY, CTRL], "l", lazy.function(kick_to_next_screen)),
    Key([], "F12", lazy.group["scratchpad"].dropdown_toggle("diary")),
    Key([CTRL], "F12", lazy.group["scratchpad"].dropdown_toggle("task")),
    # Multimedia
    # Volume
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -D pulse sset Master 2%+")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -D pulse sset Master 2%-")),
    Key([], "XF86AudioMute", lazy.spawn("amixer -D pulse sset Master toggle")),
    # Brightness
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +5%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 5%-")),
    Key([], "XF86TouchpadToggle", lazy.spawn("i3lock-fancy")),
    Key([MODKEY], "Print", lazy.spawn("flameshot gui")),
    Key([MODKEY, SHIFT], "Print", lazy.spawn("flameshot launcher")),
]

# Keybindings for switching groups
for g, k in zip(groups, [GRAVE] + list("asdfgyuiop")):
    keys.append(Key([MODKEY], k, lazy.group[g.name].toscreen()))
    # keys.append(Key([MODKEY], k, lazy.function(go_to_group_or_switch_screen, g.name)))
    keys.append(Key([MODKEY, SHIFT], k, lazy.window.togroup(g.name)))
    keys.append(Key([MODKEY, CTRL], k, lazy.window.togroup(g.name)))
    keys.append(Key([MODKEY, SHIFT], k, lazy.window.togroup(g.name)))
    spawns_for_group = g.spawn or []
    for spawn in spawns_for_group:
        keys.append(Key([MODKEY, ALT], k, lazy.spawn(spawn)))


def modifier_window_commands(match, spawn, *keys):
    # Use switch_window by default (just mod)
    # Use pull_window_here with additional ctrl
    # spawn new window with additional shift
    # Use pull_window_group_here with additional shift (mod, "shift", "control")
    mapping = (
        ([mod], switch_window(**match)),
        ([mod, "control"], pull_window_here(**match)),
        ([mod, "shift"], lazy.spawn(spawn)),
        ([mod, "shift", "control"], pull_window_group_here(**match)),
    )
    return [Key(mods, key, command) for mods, command in mapping for key in keys]
