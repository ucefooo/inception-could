#!/bin/bash
set -e

# Wait for MySQL to be ready
# until wp db check --path=/var/www/html --allow-root 2>/dev/null; do
#     echo "Waiting for MySQL to be ready..."
#     sleep 2
# done

# Remove existing wp-config if it exists
rm -rf /var/www/html/wp-config.php

# Setup WordPress if not already configured
if [ ! -f /var/www/html/wp-config.php ]; then
    # Ensure directory exists and has correct permissions
    mkdir -p /var/www/html/
    chown -R www-data:www-data /var/www/html/
    chmod 755 /var/www/html/

    # Download WordPress core
    wp core download --path=/var/www/html/ --allow-root --force

    # Create wp-config.php
    wp config create \
        --dbname=${DB_NAME} \
        --dbuser=${WORDPRESS_DB_USER} \
        --dbpass=${WORDPRESS_DB_PASSWORD} \
        --dbhost=${DB_HOST} \
        --path=/var/www/html \
        --allow-root \
        --skip-check \
        --extra-php <<PHP
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
PHP

    # Install WordPress
    wp core install \
        --url=${WORDPRESS_ADMIN_URL} \
        --title="${WORDPRESS_TITLE}" \
        --admin_user=${WORDPRESS_ADMIN_NAME} \
        --admin_password=${WORDPRESS_ADMIN_PASS} \
        --admin_email=${WORDPRESS_ADMIN_EMAIL} \
        --path=/var/www/html \
        --allow-root

    # Final permissions setup
    chown -R www-data:www-data /var/www/html/
    find /var/www/html/ -type d -exec chmod 755 {} \;
    find /var/www/html/ -type f -exec chmod 644 {} \;
fi

# Start PHP-FPM
exec php-fpm7.3 -F