import pytest #  noqa

def test_containers(compose):
    # There should be 9 containers in total.
    assert len(compose.containers) == 9

    for container in compose.containers:
        container.reload()
        assert container.status == "running"
