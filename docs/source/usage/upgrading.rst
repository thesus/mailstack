Upgrading
=========


Upgrading SOGo
--------------

Most of the work of upgrading SOGo is done for you by Mailstack. Sometimes SOGo's webmailer does not work after an update. This is usually due to out-of-date Javascript files that are cached in SOGo's volume. Just delete the ``sogo-web`` volume and restart the SOGo container.
