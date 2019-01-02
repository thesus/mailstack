import secrets
import string

from email.message import EmailMessage
from jinja2 import Template

from imaplib import IMAP4
from smtplib import SMTP

def create_password(length=10):
    """Creates a password with a given length."""
    alphabet = string.ascii_letters + string.digits
    return ''.join(secrets.choice(alphabet) for i in range(length))

def load_env_file(filename):
    """Loads all environment variables from a given file."""
    variables = {}
    with open(filename) as f:
        for line in f:
            # Skip comments and empty lines
            if line.startswith("#") or "=" not in line:
                continue

            key, value = line.strip().split("=", 1)
            variables[key] = value

    return variables


def compile_template(input_file, output_file, variable_dict):
    """Compiles a jinja2 template."""
    # Not a good idea with big files.
    with open(input_file) as f:
        data = f.read()

    template = Template(data)
    compiled = template.render(variable_dict)

    output_file.write(compiled)


def create_imap_connection():
    """Creates an secured imap connection to localhost."""
    imap = IMAP4("localhost", 143)
    imap.starttls()

    return imap

def create_smtp_connection(address="localhost"):
    """Creates an secured smtp connection to localhost."""
    smtp = SMTP(address, 587)

    smtp.ehlo()
    smtp.starttls()
    smtp.ehlo()

    return smtp

def craft_email(from_email, to_email, subject, content):
    """Crafts an email and returns it."""
    message = EmailMessage()
    message.set_content(content)

    message['Subject'] = subject
    message['From'] = from_email
    message['To'] = to_email

    return message
