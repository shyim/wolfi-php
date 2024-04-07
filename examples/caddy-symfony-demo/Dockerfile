# runtime dependencies
FROM ghcr.io/shyim/wolfi-php/caddy:8.2 as base
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

# build final image

FROM base

# uid 82 is www-data
COPY --from=composer --chown=82 /app /var/www/html

CMD [ "/usr/bin/hivemind" , "/etc/Procfile" ]
