import imaplib
import secrets
import string

from jinja2 import Template

def create_password(length=10):
    alphabet = string.ascii_letters + string.digits
    return ''.join(secrets.choice(alphabet) for i in range(length))

def load_env_file(filename):
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

    # Not a good idea with big files.
    with open(input_file) as f:
        data = f.read()

    template = Template(data)
    compiled = template.render(variable_dict)

    output_file.write(compiled)

def create_imap_connection():
    imap = imaplib.IMAP4("localhost", 143)
    imap.starttls()

    return imap
