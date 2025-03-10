FROM debian:buster

RUN apt-get update -y && apt-get install nginx openssl -y \
    && mkdir -p /etc/nginx/ssl/ && \
    openssl req -x509 -newkey rsa:2048 -keyout /etc/nginx/ssl/localhost.key -out /etc/nginx/ssl/localhost.crt -days 365 -subj '/CN=0.0.0.0' -nodes

COPY ./config/config-nginx /etc/nginx/sites-enabled/default

CMD [ "nginx", "-g" , "daemon off;"]