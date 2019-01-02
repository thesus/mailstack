# Testing
Testing of the mailstack. Currently unfinished. General architecture:
The tests are written in python and held together by the pytest-package.

To run the tests, create a virtual environment and install the dependencies.

`python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt`


## TODO

- docker-compose setup (running docker-compose)
- automated setup of ssl and integrated ldap
- sending a testmail from python client smtp
- receiving mail with another account via imap
- Diffie-hellman file checking
- recipient-delimiter test
- pop3 connection and email polling
- tests with an external mailserver? maybe a setup with two servers simualtanously
- rspamd spam detection with spam mail with forced rejection
- spam/ham learning -> moving mails to the spam folder via imap
- connection to sogo, maybe even login (selenium?)
- checking for open ports
- upgrade tests: storing a succesfull test, upgrade the images and restart
- S2S connection, test via telnet.
