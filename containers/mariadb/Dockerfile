FROM debian:buster

COPY ./tools/setup_database.sql /setup_database.sql
COPY ./tools/init.sh /init.sh

RUN apt-get update -y && \
    apt-get install -y mariadb-server mariadb-client gettext-base && \
    sed -i 's/.*#port*./port/' /etc/mysql/mariadb.conf.d/50-server.cnf && \
    sed -i 's/.*bind-address*./#bind-address/' /etc/mysql/mariadb.conf.d/50-server.cnf && \
    mkdir -p /var/log/mysql && \
    touch /var/log/mysql/error.log && \
    chown -R mysql:mysql /var/log/mysql && \
    chmod +x /init.sh

CMD [ "/init.sh" ]