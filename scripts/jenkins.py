import json
from os.path import expanduser
import sys

DEFAULT_JENKINS_CONFIG = expanduser('~/.config/jenkins/config.json')


class Config:

    def __init__(self, path=DEFAULT_JENKINS_CONFIG):
        self.path = path
        self._config = {}
        self._read_config()

    def _read_config(self):
        with open(self.path) as f:
            self._config = json.load(f)

    def find_by_alias(self, alias):
        aliases = self._config.get('aliases', {})
        if alias not in aliases:
            raise Exception(f'Alias {alias} not found in configuration')

        job = aliases[alias]

        # Find the project
        project_id = job['project'] or self.default_project
        project = self.projects[project_id]

        # Find the specific environment within the project
        environment_id = job['environment'] or alias
        environment = project['environments'][environment_id]

    @property
    def aliases(self):
        return self._config.get('aliases', {}).keys()


config = Config()


# ACTIONS

def deploy(argv):
    """
    Runs a deployment job in Jenkins.
    Usage:

        $ jenkins deploy <job-alias>

    To see available jobs run:

        $ jenkins list jobs

    """
    print('Deploying...')


def status(argv):
    print('Statusing...')


def ls(argv):
    for alias in config.aliases:
        print(alias)


def help(argv):
    if len(argv) > 1:
        print_usage('Too many arguments')
    elif len(argv) == 0:
        print_usage('jenkins cli tool to communicate with jenkins in python')
    else:
        action = get_action(argv[0])
        if action is None:
            print('Unknown action')
            print('Please type one of:')
            for action in ACTIONS:
                if action != help:
                    print('    help ' + action.__name__)
        else:
            print(action.__doc__)


# ARGS parsing


ACTIONS = [
    deploy,
    status,
    ls,
    help
]


def get_action(action):
    actions = [a for a in ACTIONS if a.__name__ == action]
    if len(actions) == 1:
        return actions[0]
    else:
        return None


def print_usage(reason=None):
    if reason:
        print(reason)
    print(main.__doc__)


def main():
    '''
    Usage:
        jenkins deploy
        jenkins status
        jenkins ls
        jenkins help
    '''
    action = sys.argv[1] if len(sys.argv) > 1 else None
    if not action:
        print_usage('Action not provided')
        exit(-1)

    f = get_action(action)
    if f is not None:
        f(sys.argv[2:])
    else:
        print_usage(f'Action "{action}" invalid')
        exit(-1)


if __name__ == '__main__':
    main()
