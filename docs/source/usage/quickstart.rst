Getting started
===============

Requirements:

* docker version 18.03.1 or higher
* docker-compose version 1.21.1 or higher

We're using `config-management`_ to compile a custom ``docker-compose.yml`` file.
Once you've compiled ``config-management`` change to the mailstack git repository and create your custom configuration with:

.. _config-management: https://dev.cryptec.at/david/config-management


.. code:: console

  config-management gen >> config.yml


Now you can start editing and customizing your freshly created `config.yml`. Once you`re happy with the settings run:


.. code:: console

  config-management


Now you should see a freshly created `docker-compose.yml` in your current directory. Take a glance at it or use it right away with:


.. code:: console

  docker-compose up -d


Settings overview
=================

+---------------------------------------+--------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| Setting                               | Default                              | Description                                                                                                          |
+---------------------------------------+--------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| ``domain``                            | none                                 | Sets Postfix' ``myorigin``, ``mydomain``, ``virtual_mailbox_domains``, and SoGo's ``mail_domain`` to this value.     |
|                                       |                                      | Set this to the domain you are going to setup e-mail services for.                                                   |
+---------------------------------------+--------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| ``address``                           | none                                 | Used as an external domain for your SoGo webinterface. if ``exposed`` is true and Caddy is supposed to handle        |
|                                       |                                      | certificates, this address has to be publicly known and the A (or AAAA) record has to point to an IP address where   |
|                                       |                                      | port 80 and 443 are forwarded to the Caddy container.                                                                |
+---------------------------------------+--------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| ``ldap.search_base``                  | ``ou=People,dc=example,dc=com``      | User objects will be searched within this LDAP node.                                                                 |
+---------------------------------------+--------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| ``ldap.server``                       | ``ldap://ldap:389``                  | URL of the LDAP server used for authentication.                                                                      |
+---------------------------------------+--------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| ``ssl.certificate``                   | ``caddy``                            | Set this to ``caddy`` if you want Caddy to take care of certificates with Let's Encrypt. Set this to ``self``        |
|                                       |                                      | if you will take care of getting certificates yourself. Set this to `none` if you are not going to use TLS.          |
+---------------------------------------+--------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| ``ssl.cert_path``                     | ``/etc/certificates/fullchain.pem``  | If you set `ssl.certificate` to `self`, this path points to the certificate file.                                    |
+---------------------------------------+--------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| ``ssl.key_path``                      | ``/etc/certificates/privkey.pem``    | If you set `ssl.certificate` to `self`, this path points to the certificate key.                                     |
+---------------------------------------+--------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| ``caddy.internal``                    | ``false``                            | The Caddy instance is reachable from the outside world by default. If you want to change this behavior, set this     |
|                                       |                                      | key to ``true``. Caddy will then be available in the network ``expose.mailstack.caddy``.                             |
|                                       |                                      | Expose means in this case outside the mailstack.                                                                     |
+---------------------------------------+--------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| ``caddy.ip_address``                  | none                                 | Public IP address of the Caddy container.                                                                            |
+---------------------------------------+--------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| ``caddy.email``                       | none                                 | E-mail address sent to Let's Encrypt for notification e-mails, if ``ssl.certificate`` is set to ``caddy``.           |
+---------------------------------------+--------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| ``postfix.ldap.bind_dn``              | none                                 | Bind DN used by Postfix to access LDAP.                                                                              |
+---------------------------------------+--------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| ``postfix.ldap.bind_pw``              | none                                 | Password used by Postfix to access LDAP.                                                                             |
+---------------------------------------+--------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| ``postfix.ldap.domain``               | none                                 | ?                                                                                                                    |
+---------------------------------------+--------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| ``dovecot.ldap.bind_dn``              | none                                 | Bind DN used by Dovecot to access LDAP.                                                                              |
+---------------------------------------+--------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| ``dovecot.ldap.bind_pw``              | none                                 | Password used by Dovecot to access LDAP.                                                                             |
+---------------------------------------+--------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| ``dovecot.ldap.server``               | none                                 | Same as ``ldap.server``, but in HOST:IP form instead of URL form.                                                    |
+---------------------------------------+--------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| ``rspamd.controller.password``        | ``''``                               | Rspamd hashed password with ``PBKDF2-Blake2`` for accessing the rspamd webinterface.                                 |
+---------------------------------------+--------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| ``rspamd.controller.enable_password`` | ``''``                               | Rspamd hashed password with ``PBKDF2-Blake2`` for feeding Spam information into Rspamd.                              |
+---------------------------------------+--------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| ``sogo.ldap.bind_dn``                 | none                                 | Bind DN used by Sogo to access LDAP.                                                                                 |
+---------------------------------------+--------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| ``sogo.ldap.bind_pw``                 | none                                 | Password used by Sogo to access LDAP.                                                                                |
+---------------------------------------+--------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| ``sogo.debug``                        | ``NO``                               | Set to ``'YES'`` to enable Sogo debug mode. Set to ``'NO'`` otherwise.                                               |
+---------------------------------------+--------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| ``postgres.user``                     | none                                 | Username for Postgres access.                                                                                        |
+---------------------------------------+--------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| ``postgres.password``                 | none                                 | Password for Postgres access.                                                                                        |
+---------------------------------------+--------------------------------------+----------------------------------------------------------------------------------------------------------------------+
| ``postgres.db``                       | ``'sogo'``                           | Database name for Sogo database.                                                                                     |
+---------------------------------------+--------------------------------------+----------------------------------------------------------------------------------------------------------------------+
