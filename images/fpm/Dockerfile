FROM ghcr.io/shyim/wolfi-php/base:latest

ARG PHP_VERSION=8.3

RUN <<EOF
set -eo pipefail
apk add --no-cache \
    php-${PHP_VERSION}-fpm 
adduser -u 82 www-data -D
mkdir -p /var/www/html
EOF

WORKDIR /var/www/html
ENV PHP_FPM_USER=www-data \
    PHP_FPM_GROUP=www-data \
    PHP_FPM_ACCESS_LOG=/proc/self/fd/2 \
    PHP_FPM_LISTEN=[::]:9000 \
    PHP_FPM_PM=dynamic \
    PHP_FPM_PM_MAX_CHILDREN=5 \
    PHP_FPM_PM_START_SERVERS=2 \
    PHP_FPM_PM_MIN_SPARE_SERVERS=1 \
    PHP_FPM_PM_MAX_SPARE_SERVERS=3 \
    PHP_FPM_PM_MAX_REQUESTS=0 \
    PHP_FPM_PM_STATUS_PATH=/-/fpm/status \
    PHP_FPM_PING_PATH=/-/fpm/ping \
    PHP_ERROR_REPORTING= \
    PHP_DISPLAY_ERRORS=On \
    PHP_DISPLAY_STARTUP_ERRORS=On \
    PHP_UPLOAD_MAX_FILESIZE=2M \
    PHP_POST_MAX_SIZE=2M \
    PHP_MAX_EXECUTION_TIME=30 \
    PHP_MEMORY_LIMIT=128M \
    PHP_SESSION_HANDLER=files \
    PHP_SESSION_SAVE_PATH= \
    PHP_SESSION_GC_PROBABILITY=1

COPY --link rootfs /

CMD [ "/usr/sbin/php-fpm" ]
