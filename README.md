# Mailstack
Highly configurable setup of mail related Services. This includes:

- MTA (postfix)
- MDA (dovecot)
- Spam and DKIM-Signing (rspadm)
- Webinterface (SOGo 4.0)

All services are run in separated docker containers.
That helps with platform Independency and also adds a bit of Security.
Developing and testing of new feature can be achieved quickly on a local machine without affecting a deployment.

The full documentation can be found [here](https://infrastructure.pages.cryptec.at/mailstack).

Quickstart
==========

1. Setup `config-management`, see [setup instructions](https://dev.cryptec.at/david/config-management#setup).

2. Clone the repository:
   ```shell
   $ git clone https://dev.cryptec.at/infrastructure/mailstack.git
   $ cd mailstack
   ```

3. Run initial step of `config-management`:
   ```
   $ config-management generate-template > config.yml
   ```

4. Adjust values in `config.yml`.

5. Apply values to templates:
   ```shell
   $ config-management
   ```

6. Startup the system:
   ```shell
   $ docker-compose up
   ```
