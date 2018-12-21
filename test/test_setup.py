import pytest #  noqa

def test_created_containers(compose):
    # There should be 9 containers in total.
    assert len(compose.containers) == 9
