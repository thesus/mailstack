import pytest

from mailstack.utils import (
    craft_email,
    create_smtp_connection
)

from smtplib import (
    SMTPDataError,
    SMTPSenderRefused
)

def test_sending_mail(smtp_connection, compose):
    """Tests sending a normal message with an authenticated user."""
    address = compose.users[0]['email_address']

    message = craft_email(
        from_email=address,
        to_email=address,
        subject="Testmail",
        content="This is a testmail to myself."
    )

    # If sending is not successfull, an error will be raised.
    smtp_connection.send_message(message)


def test_spam_rejection(smtp_connection, compose):
    """Tests the internal rejection of the spam testmail."""
    address = compose.users[0]['email_address']

    spam_string = "XJS*C4JDBQADN1.NSBN3*2IDNEN*GTUBE-STANDARD-ANTI-UBE-TEST-EMAIL*C.34X"

    message = craft_email(
        from_email=address,
        to_email=address,
        subject="Spamtest",
        content=spam_string
    )

    # Expect that sending the message is unsuccessfull.
    # Rspamd should prevent sending the mail.
    with pytest.raises(SMTPDataError):
        smtp_connection.send_message(message)


def test_sending_unauth(compose):
    """Expect that the email can't be send due to missing authentication. Open relay prevention."""

    message = craft_email(
        from_email="test@notexisting.tld",
        to_email="test@localdomain",
        subject="Testing unauth",
        content="Unauthenticated email"
    )

    smtp_connection = create_smtp_connection("localhost")

    smtp_connection.send_message(message)

    with pytest.raises(SMTPSenderRefused):
        smtp_connection.send_message(message)


