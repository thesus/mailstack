from containers import Setup

import pytest

@pytest.fixture(scope="module")
def compose():
    setup = Setup("docker-compose.yml")

    # Create containers
    setup.create()

    # Setup ldap
    setup.setup_ldap()

    yield setup

    print("Removing containers, volumes and networks...")
    setup.dismantle()

