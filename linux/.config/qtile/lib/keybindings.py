from libqtile.config import Key
from lib.keys import (
    ALT, TAB, CTRL, SHIFT, RETURN, SPACE, GRAVE,
    DELETE, PRINT, BACKSPACE, SEMICOLON, COMMA
)
from libqtile.command import lazy
from lib.settings import (
    MODKEY, DEFAULT_TERMINAL, APP_LAUNCHER,
    DEFAULT_TERMINAL
)
from lib.utils import (exe, term_exe, kick_to_next_screen, go_to_next_screen,
        go_to_group_or_switch_screen)
from lib.groups import groups

# Keybindings
keys = [

    # General
    Key([MODKEY, SHIFT], 'r', lazy.restart()),
    Key([MODKEY], RETURN, exe(DEFAULT_TERMINAL)),
    Key([MODKEY], BACKSPACE, exe(DEFAULT_TERMINAL)),
    Key([MODKEY], 'e', exe('dmenu_run')),
    Key([MODKEY], 'z', exe('morc_menu')),
    Key([MODKEY, SHIFT], 'q', lazy.window.kill()),
    Key([MODKEY, CTRL], 'q', lazy.window.kill()),
    Key([MODKEY], 'F5', term_exe('mocp')),
    Key([MODKEY], DELETE, exe('logoff')),
    Key([MODKEY], 'c', exe('compton-toggle')),
    Key([MODKEY, SHIFT], 'e', lazy.shutdown()),

    # TODO: Add Screenshots like i3-scrot
    Key([MODKEY], PRINT, lazy.spawn(["scrot", "-s"])),

    # Move Focus
    Key([ALT], TAB, lazy.layout.next()),
    Key([ALT, SHIFT], TAB, lazy.layout.previous()),
    Key([MODKEY], 'h', lazy.layout.left()),
    Key([MODKEY], 'j', lazy.layout.down()),
    Key([MODKEY], 'k', lazy.layout.up()),
    Key([MODKEY], 'l', lazy.layout.right()),
    #Key([MODKEY, SHIFT], SPACE, lazy.layout.flip()),

    # Move Window
    Key([MODKEY, SHIFT], 'j', lazy.layout.shuffle_down()),
    Key([MODKEY, SHIFT], 'k', lazy.layout.shuffle_up()),
    Key([MODKEY, SHIFT], 'h', lazy.layout.shuffle_left()),
    Key([MODKEY, SHIFT], 'l', lazy.layout.shuffle_right()),
    Key([MODKEY, CTRL], 'j', lazy.layout.shuffle_down()),
    Key([MODKEY, CTRL], 'k', lazy.layout.shuffle_up()),
    Key([MODKEY, CTRL], 'h', lazy.layout.shuffle_left()),
    Key([MODKEY, CTRL], 'l', lazy.layout.shuffle_right()),
    Key([MODKEY], COMMA, lazy.layout.swap_main()),


    # Alter Window Size
    Key([MODKEY], 'minus', lazy.layout.shrink()),
    Key([MODKEY], 'equal', lazy.layout.grow()),
    Key([MODKEY, SHIFT], 'equal', lazy.layout.reset()),
    Key([MODKEY, CTRL], 'equal', lazy.layout.reset()),
    Key([MODKEY], 'm', lazy.layout.maximize()),
    Key([MODKEY], 'n', lazy.layout.normalize()),

    # Layout
    Key([MODKEY, CTRL], SPACE, lazy.window.toggle_floating()),
    Key([MODKEY, SHIFT], SPACE, exe('switchkblayout')),
    Key([MODKEY], SPACE, lazy.next_layout()),
    Key([MODKEY], 'r', lazy.window.toggle_fullscreen()),

    # Screens
    # Key([MODKEY], 'i', lazy.function(go_to_next_screen, -1)),
    # Key([MODKEY], 'o', lazy.function(go_to_next_screen)),
    Key([MODKEY], 'q', lazy.function(go_to_next_screen, -1)),
    Key([MODKEY], 'w', lazy.function(go_to_next_screen)),
    Key([MODKEY], SEMICOLON, lazy.function(go_to_next_screen)),
    Key([MODKEY, CTRL], 'h', lazy.function(kick_to_next_screen, -1)),
    Key([MODKEY, CTRL], 'l', lazy.function(kick_to_next_screen)),
]

# Keybindings for switching groups
for g, k in zip(groups, [GRAVE] + list('asdfgyuiop')):
    # keys.append(Key([MODKEY], k, lazy.group[g.name].toscreen()))
    keys.append(Key([MODKEY], k, lazy.function(go_to_group_or_switch_screen, g.name)))
    keys.append(Key([MODKEY, SHIFT], k, lazy.window.togroup(g.name)))
    keys.append(Key([MODKEY, CTRL], k, lazy.window.togroup(g.name)))
    

def modifier_window_commands(match, spawn, *keys):
    # Use switch_window by default (just mod)
    # Use pull_window_here with additional ctrl
    # spawn new window with additional shift
    # Use pull_window_group_here with additional shift (mod, "shift", "control")
    mapping = (
        ([mod], switch_window(**match)),
        ([mod, "control"], pull_window_here(**match)),
        ([mod, "shift"], lazy.spawn(spawn)),
        ([mod, "shift", "control"], pull_window_group_here(**match)))
    return [Key(mods, key, command)
            for mods, command in mapping
            for key in keys]


