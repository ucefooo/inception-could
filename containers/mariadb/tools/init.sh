#!/bin/bash

# Replace environment variables in the SQL file
envsubst < /setup_database.sql > /setup_database_processed.sql

# Create MySQL config with root password
cat > /root/.my.cnf << EOF
[client]
user=root
password=${DB_ROOT_PASSWORD}
EOF

chmod 600 /root/.my.cnf

# Initialize MariaDB data directory if it doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    
    # Start temporary MySQL server
    mysqld --user=mysql --bootstrap << EOF
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${DB_ROOT_PASSWORD}');
FLUSH PRIVILEGES;
EOF
fi

# Start MySQL and execute setup
mysqld_safe --datadir=/var/lib/mysql --user=mysql &

# Wait for MySQL to be ready
until mysqladmin ping >/dev/null 2>&1; do
    echo "Waiting for MySQL to be ready..."
    sleep 2
done

# Execute the processed SQL file
mysql < /setup_database_processed.sql

mysqladmin shutdown

# Keep the script running to keep container alive
# tail -f /var/log/mysql/error.log 
exec "$@"