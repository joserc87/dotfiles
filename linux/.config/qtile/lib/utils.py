"""
Helper functions to run programs
"""
import os
import re
import subprocess
from libqtile.command import lazy

from lib.settings import DEFAULT_TERMINAL


def exe(*args, **kwargs):
    """ Just does the lazy.span """
    return lazy.spawn(*args, **kwargs)


def term_exe(command):
    """ Run command from the terminal """
    # Change DEFAULT_TERMINAL with get_alternatives
    return exe(f'{DEFAULT_TERMINAL} -e {command}')


def get_bin(file):
    """ Gets the path of a script from the bin subfolder """
    return os.path.join(os.path.dirname(__file__), os.pardir, f'bin/{file}')


def get_alternatives(alternatives):
    """
    Parses $PATH and searchs for best match with given list.
    Returns False or if search wasn't successful.
    Returns False if given isn't a list.
    """

    if type(alternatives) is not list:
        return False

    results = []
    for d in os.environ['PATH'].split(':'):
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
        command = command.split(' ')

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
    terminal = get_alternatives([
        'alacritty',
        'terminator',
        'gnome-terminal',
        'xterm'
    ])
    autostart = get_bin('autostart')
    lock = get_bin('lock')
    suspend = get_bin('suspend')
    hibernate = get_bin('hibernate')
