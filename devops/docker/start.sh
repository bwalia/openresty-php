#!/bin/bash

set -x

/usr/bin/supervisord -c /etc/supervisord.conf
    # Give process chance to create php socket
    # Sleep 60

# while : ; do
#     [[ -f "/var/run/php-fpm/php8-fpm.sock" ]] && break
#     echo "Pausing until /var/run/php-fpm/php8-fpm.sock file path exists."
#     sleep 1
# done

# chmod +x /var/run/php-fpm/php8-fpm.sock
# chmod 777 -R /var/run/php-fpm/php8-fpm.sock
# chown -R www-data:www-data /var/run/php-fpm/php8-fpm.sock
