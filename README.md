# Mailstack
Highly configurable setup of mail related Services. This includes:

- MTA (postfix)
- MDA (dovecot)
- Spam and DKIM-Signing (rspadm)
- Webinterface (SOGo 4.0)

All services are run in separated docker containers.
That helps with platform Independency and also adds a bit of Security.
Developing and testing of new feature can be achieved quickly on a local machine without affecting a deployment.

The full documentation can be found [here](https://infrastructure.pages.cryptec.at/mailstack). It includes a [quickstart guide](https://infrastructure.pages.cryptec.at/mailstack/usage/quickstart.html).
