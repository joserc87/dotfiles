#!/usr/bin/python
import sys
from libqtile.command import InteractiveCommandClient

c = InteractiveCommandClient()


def get_group_by_index(idx):
    _, groups = c.items('group')
    return c.group[groups[idx]]


def is_group_shown(group):
    screen_index = group.info()['screen']
    return screen_index is not None


def other_screen():
    current_screen = c.group.screen.info()['index']
    return 1 - current_screen


def get_target_screen():
    if len(sys.argv) >= 2:
        return int(sys.argv[1])
    else:
        return 7


def main():
    group = get_group_by_index(get_target_screen())
    if not is_group_shown(group):
        print('Showing group')
        group.toscreen(other_screen())
    else:
        print('Group already in screen. Doing nothing')

if __name__ == '__main__':
    main()
