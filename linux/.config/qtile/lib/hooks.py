from libqtile import hook

from lib.utils import command, execute
from lib.settings import FLOATING_WINDOWS


@hook.subscribe.startup
def startup():
    execute(command.autostart)


@hook.subscribe.client_new
def floating_dialogs(window):
    dialog = window.window.get_wm_type() == "dialog"
    transient = window.window.get_wm_transient_for()
    window_name = window.name.lower()

    if dialog or transient:
        window.floating = True

    for i in FLOATING_WINDOWS:
        if i in window_name:
            window.floating = True
