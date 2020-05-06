from libqtile.config import Key
from lib.keys import (
    ALT, TAB, CTRL, SHIFT, RETURN, SPACE, GRAVE
)
from libqtile.command import lazy
from lib.settings import (
    MODKEY, DEFAULT_TERMINAL, APP_LAUNCHER,
    DEFAULT_TERMINAL
)
from lib.keys import DELETE
from lib.utils import exe, term_exe
from lib.groups import groups

# Keybindings
keys = [

    # General
    Key([MODKEY, SHIFT], 'r', lazy.restart()),
    Key([MODKEY], 'Return', exe(DEFAULT_TERMINAL)),
    Key([MODKEY], 'd', exe('dmenu_run')),
    Key([MODKEY], 'z', exe('morc_menu')),
    Key([MODKEY, SHIFT], 'q', lazy.window.kill()),
    Key([MODKEY], 'F5', term_exe('mocp')),
    Key([MODKEY], DELETE, exe('logoff')),
    Key([MODKEY], 'c', exe('compton-toggle')),
    # TODO: Add Screenshots like i3-scrot

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
    Key([MODKEY, SHIFT], 'h', lazy.layout.shuffle_right()),
    Key([MODKEY, SHIFT], 'l', lazy.layout.shuffle_left()),
    Key([MODKEY], 'i', lazy.layout.swap_main()),


    # Alter Window Size
    Key([MODKEY], 'minus', lazy.layout.shrink()),
    Key([MODKEY], 'plus', lazy.layout.grow()),
    Key([MODKEY], 'equal', lazy.layout.reset()),
    Key([MODKEY], 'm', lazy.layout.maximize()),
    Key([MODKEY], 'n', lazy.layout.normalize()),

    # Layout
    Key([MODKEY, CTRL], SPACE, lazy.window.toggle_floating()),
    Key([MODKEY, SHIFT], SPACE, lazy.prev_layout()),
    Key([MODKEY], SPACE, lazy.next_layout()),
    Key([MODKEY], 'f', lazy.window.toggle_fullscreen()),
]

# Keybindings for switching groups
for g, k in zip(groups, [GRAVE] + list('1234567890')):
    keys.append(Key([MODKEY], k, lazy.group[g.name].toscreen()))
    keys.append(Key([MODKEY, SHIFT], k, lazy.window.togroup(g.name)))
