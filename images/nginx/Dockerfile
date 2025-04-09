ARG PHP_VERSION=8.3
FROM ghcr.io/shyim/wolfi-php/fpm:${PHP_VERSION}

ENV PHP_FPM_LISTEN=/tmp/php-fpm.sock \
    PHP_FPM_ACCESS_LOG=/dev/null \
    HIVEMIND_SKIP_ENV=1

RUN <<EOF
set -eo pipefail
apk add --no-cache \
    hivemind \
    nginx
EOF

COPY --link rootfs/etc /etc
COPY --link --chown=82:82 rootfs/var/www/html /var/www/html
EXPOSE 8000

CMD ["/usr/bin/hivemind", "/etc/Procfile"]
