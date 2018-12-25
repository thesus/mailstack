import pytest

from mailstack.utils import create_imap_connection

def test_correct_folders(imap_connection):
    folders = [
        b'(\\HasNoChildren \\Drafts) "/" Drafts',
        b'(\\HasNoChildren \\Junk) "/" Spam',
        b'(\\HasNoChildren \\Trash) "/" Trash',
        b'(\\HasNoChildren \\Sent) "/" Sent',
        b'(\\HasNoChildren) "/" INBOX'
    ]

    listing = imap_connection.list()

    assert listing[0] == "OK"

    assert len(listing[1]) == len(folders)

    assert any(x in folders for x in listing[1])


@pytest.mark.skip(reason="Sharing mailboxes is currently half broken.")
def test_create_share_mailbox(imap_connection, compose):
    imap_connection.create("testfolder")

    acl = "lrwstipekxa"
    imap_connection.setacl(
        "testfolder",
        compose.users[1]["email_address"],
        acl
    )

    second_connection = create_imap_connection()
    second_connection.login(
        compose.users[1]['email_address'],
        compose.users[1]['password']
    )

    subscribe_folder = "shared/" + compose.users[0]['email_address']

    subscription = second_connection.subscribe(subscribe_folder)

    print(subscription)

    listings = second_connection.list()

    second_acl = second_connection.getacl(subscribe_folder)

    assert second_acl[0] == "OK"
    assert second_acl[1] == acl

    assert (b'(\\Noselect \\HasNoChildren) "/" ' + subscribe_folder) in listings[1]
