import atexit
import subprocess


class Compose:
    """
    Manages an instance of compose.
    """

    def __init__(self, composefile, DEBUG=False):
        self.base_command = ["docker-compose", "-f", composefile]

        # Automatically dismantle compose on process exit.
        if not DEBUG:
            atexit.register(self.cleanup)

    def cmd(self, arg):
        if type(arg) == list:
            l = list(self.base_command)
            l.extend(arg)
        else:
            l = list(self.base_command)
            l.append(arg)
        print(l)
        return l

    def pull(self):
        """ Pulls images specified in Compose file. """
        subprocess.run(
            self.cmd("pull")
        )

    def create(self):
        """ Starts the containers specified in Compose file. """
        # Create containers but don't start them.
        # They will be started gradually to allow a controlled setup.
        subprocess.run(
            self.cmd(["up", "--no-start"]),
        )

    def get_ids(self):
        """ Returns a list of all container_ids """
        process = subprocess.run(
                self.cmd(["ps", "-q"]),
                stdout=subprocess.PIPE
        )

        # decode binary data and return them as list splitted on new line.
        return process.stdout.decode('UTF-8').splitlines()

    def cleanup(self):
        """ Remove compose instance. """
        subprocess.run(
            self.cmd(["--log-level", "CRITICAL", "down", "-v"])
        )
