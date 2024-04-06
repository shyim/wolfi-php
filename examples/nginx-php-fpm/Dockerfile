FROM ghcr.io/shyim/wolfi-php/base:latest

ARG PHP_VERSION=8.3

RUN <<EOF 
set -e
apk add --no-cache \
    overmind \
    nginx \
    php-${PHP_VERSION}-fpm
adduser -u 82 www-data -D
chown -R www-data:www-data /var/lib/nginx
EOF

USER www-data
COPY rootfs /

ENTRYPOINT ["/usr/bin/overmind", "start", "-f", "/etc/Procfile", "-s", "/tmp/overmind.sock"]
