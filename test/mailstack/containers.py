import docker

from mailstack import utils
from mailstack.compose import Compose

# setup docker client
client = docker.from_env()
REGISTRY_BASE = "dev.cryptec.at:5000/infrastructure/mailstack/"


class Setup:
    """
    Setup class to create and manage a mailstack instance for testing purposes.
    """

    def __init__(self,
            composefile,
            tmp_path):
        """ Constructs an setup instance. """
        self.compose = Compose(composefile)
        self.tmp_path = tmp_path

        # Setting up network
        self.network_names = [
            'expose.mailstack.caddy',
            'expose.mailstack.rspamd'
        ]
        self.networks = []
        # self.setup_networks()


        # Setting up volumes
        self.volume_names = [
            'certificates',
        ]
        self.volumes = []
        # self.setup_volumes()

        self.containers = []
        self.users = []


    def setup_volumes(self):
        """ Create volumes specified in __init__ """
        for name in self.volume_names:
            self.create_volume(name)

    def create_volume(self, name):
        """ Create a volume by a given name and add it to volume list. """
        self.volumes.append(
            client.volumes.create(
                name=name,
                driver='local'
            )
        )

    def setup_networks(self):
        """ Creates networks specified in __init__ """
        for name in self.network_names:
            self.create_network(name)

    def create_network(self, name):
        """ Creates a network by a given name and add it to the network list. """
        self.networks.append(
            client.networks.create(
                name=name,
                driver='bridge',
                attachable=True
            )
        )

    def create(self):
        """ Creates all containers by calling the docker-compose cli. """

        # Before creating container, pull new images
        self.compose.pull()

        # Create containers without starting them
        self.compose.create()

        for identifier in self.compose.get_ids():
            self.containers.append(
                client.containers.get(identifier)
            )

    def find_container(self, name):
        return next(container for container in self.containers if container.name == name)

    def setup_ldap(self):
        """ Setups the internal ldap server. Requires the ldap.env to be present. """

        # Filter ldap container and start it.
        ldap = self.find_container("mailstack_ldap_1")
        ldap.start()
        # Start helper container to feed passwords and default users in the ldap.
        client.containers.run(
                image=REGISTRY_BASE + "utils/ldap:latest",
                command="init",
                auto_remove=True,
                environment=utils.load_env_file("ldap.env"),
                network="mailstack_internal"
        )

    def setup_user(self, first_name, last_name, identifier, email_address):
        """ Creates an entry for a given user in the active directory """

        user = {
            "last_name": last_name,
            "first_name": first_name,
            "identifier": identifier,
            "email_address": email_address,
            "password": utils.create_password()
        }

        self.users.append(user)

        # Compile ldif
        utils.compile_template(
            "test/user.ldif.template",
            self.tmp_path / "user.ldif",
            user
        )

        # Mount for ldif
        mount = docker.types.Mount(
            target='/var/tmp',
            source=str(self.tmp_path),
            type="bind",
            read_only=True
        )

        # Run container
        container = client.containers.run(
            image=REGISTRY_BASE + "utils/ldap:latest",
            command="add /var/tmp/user.ldif",
            auto_remove=True,
            mounts=[mount],
            environment=utils.load_env_file("ldap.env"),
            network="mailstack_internal",
            detach=True
        )

        for line in container.logs(stream=True):
            print(line.strip())

    def setup_certificates(self):
        client.containers.run(
            image=REGISTRY_BASE + "utils/tls:latest",
            auto_remove=True,
            command=[
                "openssl", "req", "-x509", "-newkey", "rsa:4096", "-nodes",
                "-keyout", "/etc/certificates/key.pem", "-out", "/etc/certificates/cert.pem",
                "-subj", "/C=US/ST=A/L=B/O=C/CN=example.com",
                "-days", "365"
            ],
            volumes={
                'certificates': {
                    'bind': '/etc/certificates',
                    'mode': 'rw'
                }
            }
        )

    def dismantle(self):
        """ Removes containers and volumes that are marked as internal. """
        self.compose.cleanup()
