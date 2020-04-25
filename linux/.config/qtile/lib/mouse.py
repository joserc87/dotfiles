from libqtile.config import Drag, Click
from libqtile.command import lazy
from lib.settings import MODKEY

# This allows you to drag windows around with the mouse if you want.
mouse = [
    Drag([MODKEY], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([MODKEY], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([MODKEY], "Button2", lazy.window.bring_to_front())
]
