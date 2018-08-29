Security
--------


TLS
~~~


If the mailstack exposes port on a network interface that is reachable outside,
the use of encryption is required. Dovecot and Postfix are only available via
TLS-encrypted connections. Therefore you need to choose between the two TLS-Options.
Caddy can handle the Certificates for the entire stack, including dovecot and postfix.
Even rspamd if desired. A Volume is used to share the certificate between the containers.

If ``ssl.certificate`` is set to ``caddy``, Caddy needs a resolveable DNS-Name for the
system supply it via ``address`` in your ``config.yml``. If you don't have DNS setup or
want to use your one certificate, you can use ``self`` in order to supply your own certificate path.

We recommend putting the certificates into the Certificate Volume. If you don't have a certificate yet,
you can generate and store it in the Volume:

.. code:: console

  docker run -v certificates:/etc/certificates -it dev.cryptec.at:5000/infrastructure/mailstack/utils/tls:latest


It'll create a certificate with the name ``cert.pem`` and the according ``key.pem``. If you want to change that
behaviour, you can set the ``CERT_PATH`` and ``KEY_PATH`` Envrionment-Variables. Existing certifcates can be overwritten
with ``OVERWRITE = true``.
