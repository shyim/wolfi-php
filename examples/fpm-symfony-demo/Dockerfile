# runtime dependencies
FROM ghcr.io/shyim/wolfi-php/fpm:8.2 as base
ENV APP_ENV=prod

RUN apk add --no-cache \
    php-8.2-intl \
    php-8.2-simplexml \
    php-8.2-iconv \
    php-8.2-dom \
    php-8.2-xml \
    php-8.2-simplexml \
    php-8.2-pdo \
    php-8.2-pdo_sqlite

# download symfony demo and build it
FROM base as composer

RUN apk add --no-cache \
    git \
    composer \
    unzip \
    php-8.2 \
    php-8.2-curl \
    php-8.2-openssl \
    php-8.2-phar

WORKDIR /app
RUN git clone https://github.com/symfony/demo.git --depth=1 .
RUN composer install
RUN bin/console asset-map:compile
RUN rm -rf .git

# build fpm
FROM base as fpm

COPY --link --from=composer --chown=82 /app /var/www/html

# build nginx
FROM cgr.dev/chainguard/wolfi-base as nginx

RUN <<EOF
set -eo pipefail
apk add --no-cache nginx
adduser -u 82 www-data -D
chown -R www-data:www-data /var/lib/nginx
EOF

COPY --link nginx.conf /etc/nginx/nginx.conf
COPY --link --from=composer --chown=82 /app/public /var/www/html/public
USER www-data

CMD [ "/usr/sbin/nginx" ]
