import subprocess


class Compose:
    """
    Manages an instance of compose.
    """

    def __init__(self, composefile):
        self.base_command = [
            "docker-compose",
            "--log-level",
            "ERROR",
            "-f",
            composefile
        ]

    def cmd(self, arg):
        l = list(self.base_command)

        l.extend(arg) if type(arg) is list else l.append(arg)

        print(l)

        return l

    def pull(self):
        """ Pulls images specified in Compose file. """
        subprocess.run(
            self.cmd("pull")
        )

    def create(self):
        """ Creates the containers specified in Compose file. """
        # Create containers but don't start them.
        # They will be started gradually to allow a controlled setup.
        subprocess.run(
            self.cmd(["up", "--no-start", "--build"]),
        )

    def start(self):
        """ Starts the containers in a Compose file. """
        subprocess.run(
            self.cmd(["up", "-d"])
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
            self.cmd(["down", "-v"])
        )
