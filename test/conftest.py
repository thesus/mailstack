import pytest
import time

from mailstack.containers import Setup
from mailstack.utils import (
        create_imap_connection,
        create_smtp_connection
)

@pytest.fixture(scope="session")
def compose(request, tmpdir_factory):
    tmp_path = tmpdir_factory.mktemp("data")

    setup = Setup(
        "docker-compose.yml",
        tmp_path
    )

    # Registering teardown at the beginning
    request.addfinalizer(setup.compose.cleanup)

    # Create containers
    setup.create()

    # Setup ldap
    setup.setup_ldap()

    users = (
        ("Anton", "Oneal", "anton", "anton@example.com"),
        ("Isadora", "Mcloughlin", "isadora", "isadora@example.com")
    )

    for user in users:
        setup.setup_user(*user)

    # Setup tls
    setup.setup_certificates()

    # Start all container
    setup.compose.start()

    print("allowing 4 seconds for containers to be reachable.")
    time.sleep(4)

    return setup


@pytest.fixture(scope="session")
def imap_connection(compose):
    with create_imap_connection() as imap:
        imap.login(
            compose.users[0]['email_address'],
            compose.users[0]['password']
        )

        yield imap


@pytest.fixture(scope="session")
def smtp_connection(compose):
    with create_smtp_connection() as smtp:
        smtp.login(
            compose.users[0]['email_address'],
            compose.users[0]['password']
        )

        yield smtp
