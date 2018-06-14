# Mailstack
Highly configurable setup of mail related Services. This includes:

- MTA (postfix)
- MDA (dovecot)
- Spam and DKIM-Signing (rspadm)
- Webinterface (SOGo 4.0)

All services are run in separated docker containers.
That helps with platform Independency and also adds a bit of Security.
Developing and testing of new feature can be achieved quickly on a local machine without affecting a deployment.

## Getting started

Requirements:
- docker version 18.03.1 or higher
- docker-compose version 1.21.1 or higher

We're using [config-management](https://dev.cryptec.at/david/config-management) to compile a custom `docker-compose.yml` file.
Once you've compiled `config-management` change to the mailstack git repository and create your custom configuration with:
```bash
config-management gen >> config.yml
```

Now you can start editing and customizing your freshly created `config.yml`. Once you`re happy with the settings run:
```bash
config-management
```

Now you should see a freshly created `docker-compose.yml` in your current directory. Take a glance at it or use it right away with:
```bash
docker-compose up -d
```

For more configuration options especially regarding the `config.yml` and DNS-Settings you may need to change, head over to the full [documentation](https://dev.cryptec.at/infrastructure/).