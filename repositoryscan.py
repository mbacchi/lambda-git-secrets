from dulwich import porcelain
from gitsecrets import GitSecrets
import errno
import os
import sys


class Devnull(object):
    """
    This mimics a stream to write to for dulwich porcelain status output. Since we
    don't want to see the status this is a hack to suppress anything printing on stdout.

    Borrowed from:
    https://stackoverflow.com/questions/2929899/cross-platform-dev-null-in-python
    """
    def write(self, *_): pass


def perform_scan(path):
    gs = GitSecrets()
    if gs.scan_recursively(path):
            print("Found verboten string in path {}".format(path))


def handler(event, context):
    print("Starting repository scan lambda handler function")
    print("Repository provided from event was: {}".format(event['repository']))

    remote_repo = event['repository']
    local_repo = os.path.join(os.path.sep, "tmp", os.path.basename(event['repository']))

    ourepo = porcelain.clone(remote_repo, local_repo, errstream=Devnull())

    if os.path.exists(local_repo):
        perform_scan(local_repo)

    # remove the repo before returning?

    return "Hello"

