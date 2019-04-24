Proxy
=====

If you want to operate the mailstack behind a proxy, we recommend you to check out `caddy`_. To setup an external caddy which also manages certificates use the following docker-compose.yml and Caddyfile. For additional configuration of rspamd please see here: :ref:`reference-rspamd`. Proxying of rspamd is optional though.


.. _caddy: https://github.com/mholt/caddy


.. code-block:: yaml
   :caption: Compose file for external caddy proxy.

    version: 3

    services:
      caddy:
        image: abiosoft/caddy:no-stats
        environment:
          CADDYPATH: /etc/certificates/
        networks:
          - mailstack
        ports:
          - "80:80"
          - "443:443"
        volumes:
          - type: volume
            source: certificates
            target: /etc/certificates/
         restart: always

    network:
      mailstack:
        external:
          name: expose.mailstack.caddy

    volumes:
      certificates:
        external:


.. code-block:: none
   :caption: Configuration file for caddy

    mail.example.com {
      proxy / mailstack_caddy_1:80 {
        header_upstream x-webobjects-server-port 443
        header_upstream x-webobjects-server-name $SERVER_URL
        header_upstream x-webobjects-server-url https://mail.example.com
        transparent
        websocket
      }
    }

    # If rspamd is desired also add the following
    rspamd.example.com {
        errors stdout
        proxy / http://mailstack_rspamd_1:11334 {
            transparent
            websocket
        }
    }


This example expects the proxy to handle the ssl-certificates for the mailstack. Therefore it's important to set the correct certificate  and key location.

.. code-block:: yaml

    ssl:
      cert_path: /etc/certificates/acme/acme-v02.api.letsencrypt.org/sites/mail.example.tld/mail.example.tld.crt
      key_path: /etc/certificates/acme/acme-v02.api.letsencrypt.org/sites/mail.example.tld/mail.example.tld.key

Please make sure to replace the url with your correct domain.

