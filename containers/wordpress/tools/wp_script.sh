#!/bin/bash
set -e

rm -rf /var/www/html/wp-config.php

if [ ! -f /var/www/html/wp-config.php ]; then
    mkdir -p /var/www/html/
    chown -R www-data:www-data /var/www/html/
    chmod 755 /var/www/html/

    wp core download --path=/var/www/html/ --allow-root --force
    wp config create \
        --dbname=${DB_NAME} \
        --dbuser=${WORDPRESS_DB_USER} \
        --dbpass=${WORDPRESS_DB_PASSWORD} \
        --dbhost=${DB_HOST} \
        --path=/var/www/html \
        --allow-root \
        --skip-check

    wp core install \
        --url=${WORDPRESS_ADMIN_URL} \
        --title="${WORDPRESS_TITLE}" \
        --admin_user=${WORDPRESS_ADMIN_NAME} \
        --admin_password=${WORDPRESS_ADMIN_PASS} \
        --admin_email=${WORDPRESS_ADMIN_EMAIL} \
        --path=/var/www/html \
        --allow-root

    chown -R www-data:www-data /var/www/html/
    find /var/www/html/ -type d -exec chmod 755 {} \;
    find /var/www/html/ -type f -exec chmod 644 {} \;
fi

exec php-fpm7.3 -F