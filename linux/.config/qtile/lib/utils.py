"""
Helper functions to run programs
"""
import os
import re
import subprocess
from libqtile.lazy import lazy

from lib.settings import DEFAULT_TERMINAL


def exe(*args, **kwargs):
    """Just does the lazy.span"""
    return lazy.spawn(*args, **kwargs)


def term_exe(command):
    """Run command from the terminal"""
    # Change DEFAULT_TERMINAL with get_alternatives
    return exe(f"{DEFAULT_TERMINAL} -e {command}")


def get_bin(file):
    """Gets the path of a script from the bin subfolder"""
    return os.path.join(os.path.dirname(__file__), os.pardir, f"bin/{file}")


def get_alternatives(alternatives):
    """
    Parses $PATH and searchs for best match with given list.
    Returns False or if search wasn't successful.
    Returns False if given isn't a list.
    """

    if type(alternatives) is not list:
        return False

    results = []
    for d in os.environ["PATH"].split(":"):
        try:
            for proc in os.listdir(d):
                if proc in alternatives:
                    results.append(proc)
        except:
            # If there is some error in the PATH, don't just crash, please
            pass

    for i in alternatives:
        if i in results:
            return i

    return False


def execute(command):
    """
    Opens subprocess using subprocess.Popen.
    Takes string or list.
    Returns the return of subprocess.Popen.
    """

    if not type(command) == list:
        command = command.split(" ")

    return subprocess.Popen(command)


def is_running(process):
    s = subprocess.Popen(["ps", "axw"], stdout=subprocess.PIPE)
    for x in s.stdout:
        if re.search(process, x):
            return True
        return False


def execute_once(command):
    if not is_running(command):
        return execute(command)


class command:
    terminal = get_alternatives(["alacritty", "terminator", "gnome-terminal", "xterm"])
    autostart = get_bin("autostart")
    lock = get_bin("lock")
    suspend = get_bin("suspend")
    hibernate = get_bin("hibernate")


# kick a window to another screen (handy during presentations)
def kick_to_next_screen(qtile, direction=1):
    other_scr_index = (qtile.screens.index(qtile.current_screen) + direction) % len(
        qtile.screens
    )
    othergroup = None
    for group in qtile.get_groups().values():
        if group["screen"] == other_scr_index:
            othergroup = group["name"]
            break
    if othergroup:
        qtile.move_to_group(othergroup)


def go_to_next_screen(qtile, direction=1):
    other_scr_index = (qtile.screens.index(qtile.current_screen) + direction) % len(
        qtile.screens
    )
    qtile.to_screen(other_scr_index)


def go_to_group_or_switch_screen(qtile, group_name):
    group = qtile.get_groups().get(group_name)
    if group:
        group_screen_index = group["screen"]
        current_screen_index = qtile.screens.index(qtile.current_screen)
        # group_screen_index = qtile.screens.index(screen) if screen is not None else None
        if group_screen_index is not None:
            if group_screen_index != current_screen_index:
                qtile.to_screen(group_screen_index)
            else:
                # Toggle back:
                # qtile.current_screen.cmd_prev_group()
                qtile.current_screen.cmd_toggle_group(group_name)
        else:
            # screen = qtile.screens[qtile.current_screen]
            qtile.current_screen.cmd_toggle_group(group_name)


# Taken from
# https://gist.github.com/TauPan/9c09bd9defc5ac3c9e06


def window_switch_to_screen_or_pull_group(**kwargs):
    """If the group of the window matched by match_window_re with the
    given **kwargs is in a visible on another screen, switch to the
    screen, otherwise pull the group to the current screen
    """

    def callback(qtile):
        windows = windows_matching_shuffle(qtile, **kwargs)
        if windows:
            window = windows[0]
            if window.group != qtile.current_group:
                if window.group.screen:
                    qtile.to_screen(window.group.screen.index)
                qtile.current_screen.setGroup(window.group)
            window.group.focus(window, False)

    return lazy.function(callback)


switch_window = window_switch_to_screen_or_pull_group


def make_sticky(qtile, *args):
    window = qtile.current_window
    screen = qtile.current_screen.index
    window.static(screen, window.x, window.y, window.width, window.height)


def pull_window_here(**kwargs):
    """pull the matched window to the current group and focus it
    matching behaviour is the same as in switch_to
    """

    def callback(qtile):
        windows = windows_matching_shuffle(qtile, **kwargs)
        if windows:
            window = windows[0]
            window.togroup(qtile.current_group.name)
            qtile.current_group.focus(window, False)

    return lazy.function(callback)


NUM_GAPS_LAYOUTS = 4
NUM_LAYOUTS = 5
FULL_LAYOUT = NUM_LAYOUTS - 1
SATELITE_LAYOUT = 0

SPOTIFY_GROUP = 10


def set_current_monad_layout(group, next_prev=1):
    default_monad_layout = (
        group.current_layout if 0 < group.current_layout < NUM_GAPS_LAYOUTS else 0
    )
    monad_layout = getattr(group, "monad_layout", default_monad_layout)
    monad_layout = max(1, min(monad_layout + next_prev, NUM_GAPS_LAYOUTS - 1))
    group.monad_layout = monad_layout
    return monad_layout


def current_layout_is_monad(group):
    return 0 < group.current_layout < NUM_GAPS_LAYOUTS


def increase_gaps():
    def callback(qtile):
        group = qtile.current_group
        new_layout = set_current_monad_layout(group, +1)
        if current_layout_is_monad(group):
            group.use_layout(new_layout)

    return lazy.function(callback)


def decrease_gaps():
    def callback(qtile):
        group = qtile.current_group
        new_layout = set_current_monad_layout(group, -1)
        if current_layout_is_monad(group):
            group.use_layout(new_layout)

    return lazy.function(callback)


def next_layout():
    def callback(qtile):
        group = qtile.current_group
        layout = group.current_layout
        if group.name == "spotify":
            satelite_switch_full(group, layout)
        else:
            monad_switch_full(group, layout)

    return lazy.function(callback)


def monad_switch_full(group, layout):
    if layout == FULL_LAYOUT:
        next_layout = getattr(group, "monad_layout", 2)
    elif current_layout_is_monad(group):
        next_layout = FULL_LAYOUT
    else:
        next_layout = layout + 1

    group.use_layout(next_layout)


def satelite_switch_full(group, layout):
    if layout == FULL_LAYOUT:
        next_layout = SATELITE_LAYOUT
    else:
        next_layout = FULL_LAYOUT

    group.use_layout(next_layout)


def windows_matching_shuffle(qtile, **kwargs):
    """return a list of windows matching window_match_re with **kwargs,
    ordered so that the current Window (if it matches) comes last
    """
    windows = sorted(
        [
            w
            for w in qtile.windowMap.values()
            if w.group and window_match_re(w, **kwargs)
        ],
        key=lambda ww: ww.window.wid,
    )
    idx = 0
    if qtile.current_window is not None:
        try:
            idx = windows.index(qtile.current_window)
        except ValueError:
            pass
    idx += 1
    if idx >= len(windows):
        idx = 0
    return windows[idx:] + windows[:idx]


def window_match_re(window, wmname=None, wmclass=None, role=None):
    """
    match windows by name/title, class or role, by regular expressions
    Multiple conditions will be OR'ed together
    """

    if not (wmname or wmclass or role):
        raise TypeError("at least one of name, wmclass or role must be specified")
    ret = False
    if wmname:
        ret = ret or re.match(wmname, window.name)
    try:
        if wmclass:
            cls = window.window.get_wm_class()
            if cls:
                for v in cls:
                    ret = ret or re.match(wmclass, v)
        if role:
            rol = window.window.get_wm_window_role()
            if rol:
                ret = ret or re.match(role, rol)
    except (xcffib.xproto.WindowError, xcffib.xproto.AccessError):
        return False
    return ret
