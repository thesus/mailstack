Getting started
===============


Requirements:

* docker version 18.03.1 or higher
* docker-compose version 1.21.1 or higher
* config-management version 1.1.2 or higher

We're using `config-management`_ to compile a custom ``docker-compose.yml`` file.
Once you've compiled ``config-management`` change to the mailstack git repository and create your custom configuration with:

.. _config-management: https://dev.cryptec.at/david/config-management


.. code:: console

  config-management gen >> config.yml


Now you can start editing and customizing your freshly created `config.yml`.

.. note::

  This is only a quick overview. Follow the quickstart for more detailed information.


You can use this preflight check to determine propably occurring errors.

* DNS reachable? Even from outside?
* TLS Certificates created or managed by caddy?
* LDAP Users for postfix, dovecot and SoGo?
* External Volumes and Networks created? (see `docker`_)

.. _docker: https://docs.docker.com/engine/reference/commandline/cli/


You may wan't to prepare your mailstack before you start it. If ``self`` is selected as a certificate source, it would be a good Idea
to create a certificate or copy it to the right location. If you're in a hurry just generate it and proceed. See :ref:`reference-tls`.
Besides creating or copying certificates, rspamd needs some help to hatch. The Webinterface in enabled by default, but no passwords are set.
For all configuration options and setup of passwords visit :ref:`reference-rspamd`. Some of the volumes and networks that are used by the mailstack
are ``external``, thats a docker term to describe their connectivity to other containers. Docker compose can't create them, so they need to be defined
manually. Create the following volume: ``certificates``


To create your ``docker-compose.yml`` file, run:

.. code:: console

  config-management


You should see a freshly created `docker-compose.yml` in your current directory. Take a glance at it or use it right away with:


.. code:: console

  docker-compose up -d


Once you've succesfully started all services you can prepopulate the (internal) ldap with Organizational Units and Users for dovecot, postfix and sogo.
You can find more information about setting up the OpenLDAP here: :ref:`reference-ldap`


Settings overview
=================


.. table::
  :align: center

  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | Setting                               | Default                             | Description                                                                                                        |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``domain``                            | none                                | Sets Postfix' ``myorigin``, ``mydomain``, ``virtual_mailbox_domains``, and SoGo's ``mail_domain`` to this value.   |
  |                                       |                                     | Set this to the domain you are going to setup e-mail services for.                                                 |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``address``                           | none                                | Used as an external domain for your SoGo webinterface. if ``exposed`` is true and Caddy is supposed to handle      |
  |                                       |                                     | certificates, this address has to be publicly known and the A (or AAAA) record has to point to an IP address where |
  |                                       |                                     | port 80 and 443 are forwarded to the Caddy container.                                                              |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``ldap.search_base``                  | ``ou=People,dc=example,dc=com``     | User objects will be searched within this LDAP node.                                                               |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``ldap.server``                       | ``ldap://ldap:389``                 | URL of the LDAP server used for authentication.                                                                    |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``ssl.certificate``                   | ``caddy``                           | Set this to ``caddy`` if you want Caddy to take care of certificates with Let's Encrypt. Set this to ``self``      |
  |                                       |                                     | if you will take care of getting certificates yourself. Set this to `none` if you are not going to use TLS.        |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``ssl.cert_path``                     | ``/etc/certificates/fullchain.pem`` | If you set `ssl.certificate` to `self`, this path points to the certificate file.                                  |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``ssl.key_path``                      | ``/etc/certificates/privkey.pem``   | If you set `ssl.certificate` to `self`, this path points to the certificate key.                                   |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``caddy.internal``                    | ``false``                           | The Caddy instance is reachable from the outside world by default. If you want to change this behavior, set this   |
  |                                       |                                     | key to ``true``. Caddy will then be available in the network ``expose.mailstack.caddy``.                           |
  |                                       |                                     | Expose means in this case outside the mailstack.                                                                   |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``caddy.ip_address``                  | none                                | Public IP address of the Caddy container.                                                                          |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``caddy.email``                       | none                                | E-mail address sent to Let's Encrypt for notification e-mails, if ``ssl.certificate`` is set to ``caddy``.         |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``postfix.ldap.bind_dn``              | none                                | Bind DN used by Postfix to access LDAP.                                                                            |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``postfix.ldap.bind_pw``              | none                                | Password used by Postfix to access LDAP.                                                                           |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``postfix.ldap.domain``               | none                                | ?                                                                                                                  |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``dovecot.ldap.bind_dn``              | none                                | Bind DN used by Dovecot to access LDAP.                                                                            |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``dovecot.ldap.bind_pw``              | none                                | Password used by Dovecot to access LDAP.                                                                           |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``dovecot.ldap.server``               | none                                | Same as ``ldap.server``, but in HOST:IP form instead of URL form.                                                  |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``rspamd.controller.password``        | ``''``                              | Rspamd hashed password with ``PBKDF2-Blake2`` for accessing the rspamd webinterface.                               |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``rspamd.controller.enable_password`` | ``''``                              | Rspamd hashed password with ``PBKDF2-Blake2`` for feeding Spam information into Rspamd.                            |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``rspamd.webinterface.enable``        | ``true``                            | Enable rspamd webinterface.                                                                                        |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``rspamd.webinterface.internal``      | ``false``                           | If set to false, publish rspamd only in docker network. Otherwise expose rspamd via caddy-proxy (default)          |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``rspamd.webinterface.domain``        | ``rspamd.example.com``              | SNI that is fed into caddy for routing. If no domain is set, Caddy can't do automatic ssl. Though self-signed      |
  |                                       |                                     | are possible, caddy will expose rspamd under it's default port ``11334``. For more information take a look at the  |
  |                                       |                                     | reference.                                                                                                         |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``sogo.ldap.bind_dn``                 | none                                | Bind DN used by Sogo to access LDAP.                                                                               |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``sogo.ldap.bind_pw``                 | none                                | Password used by Sogo to access LDAP.                                                                              |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``sogo.debug``                        | ``NO``                              | Set to ``'YES'`` to enable Sogo debug mode. Set to ``'NO'`` otherwise.                                             |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``postgres.user``                     | none                                | Username for Postgres access.                                                                                      |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``postgres.password``                 | none                                | Password for Postgres access.                                                                                      |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
  | ``postgres.db``                       | ``'sogo'``                          | Database name for Sogo database.                                                                                   |
  +---------------------------------------+-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
