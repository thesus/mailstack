.. _reference-ldap:

LDAP-Server
-----------

The internal LDAP-Server is a OpenLDAP living in a docker container. The Repository with further information can be found `here`_.
In order to use the Directory some things need to be prepoulated. Luckily there is a tool, that can help you with this task. To setup
the initial database use the following command:

.. _here: https://dev.cryptec.at/infrastructure/ldap


.. code:: console

  docker run -it --env-file ldap.env --network mailstack_internal dev.cryptec.at:5000/infrastructure/mailstack/utils/ldap:latest init

The environment file ``ldap.env`` is also generated via ``config-management`` and should be in the same directory as your compose file.
In order to connect to the internal ldap the container needs to be plugged into the ``internal`` network of the mailstack. If you have
not renamed the directory that contains the ``docker-compose.yml`` file, you should be good. Otherwise, fit the network binding to your needs.
To add your own ldif files, also use the ldap-utils image. You can pipe your `.ldif` file into the container.


.. code:: console

  cat user.ldif | docker run -i --env-file ldap.env --network mailstack_internal dev.cryptec.at:5000/infrastructure/mailstack/utils/ldap:latest add


You can find an example for creating a user in the repository under `examples/user.ldif`_.

.. _examples/user.ldif: https://dev.cryptec.at/infrastructure/mailstack/tree/master/examples/user.ldif
