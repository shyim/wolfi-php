ARG PHP_VERSION=8.3
FROM ghcr.io/shyim/wolfi-php/fpm:${PHP_VERSION}

ENV PHP_FPM_LISTEN=/tmp/php-fpm.sock

RUN <<EOF
set -eo pipefail
apk add --no-cache \
    overmind \
    nginx
EOF

COPY --link rootfs /
EXPOSE 8000

ENTRYPOINT ["/usr/bin/overmind", "start", "-f", "/etc/Procfile", "-s", "/tmp/overmind.sock"]
