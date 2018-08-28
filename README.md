mailstack is a complete, dockerized mailserver setup containing Dovecot, Postfix, Rspamd and Sogo. It uses [config-management](https://dev.cryptec.at/david/config-management) to create a `docker-compose.yml` file from `docker-compose.template.yml`.

Example
=======

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
