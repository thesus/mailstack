import pytest

from smtplib import SMTPDataError
from email.message import EmailMessage

def test_sending_mail(smtp_connection, compose):
    message = EmailMessage()

    message.set_content("This is a testmail to myself.")
    message['Subject'] = "Testmail"

    message['From'] = compose.users[0]['email_address']
    message['To'] = message['From']

    smtp_connection.send_message(message)


def test_spam_rejection(smtp_connection, compose):
    message = EmailMessage()

    message.set_content("XJS*C4JDBQADN1.NSBN3*2IDNEN*GTUBE-STANDARD-ANTI-UBE-TEST-EMAIL*C.34X")
    message['Subject'] = "Spamtest"

    user = compose.users[0]['email_address']
    message['From'] = user
    message['To'] = user

    with pytest.raises(SMTPDataError):
        smtp_connection.send_message(message)
