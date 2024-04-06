# runtime dependencies
FROM ghcr.io/shyim/wolfi-php/frankenphp:8.3 as base
ENV APP_ENV=prod

RUN apk add --no-cache \
    php-frankenphp-8.3-intl \
    php-frankenphp-8.3-simplexml \
    php-frankenphp-8.3-iconv \
    php-frankenphp-8.3-dom \
    php-frankenphp-8.3-xml \
    php-frankenphp-8.3-simplexml \
    php-frankenphp-8.3-pdo \
    php-frankenphp-8.3-pdo_sqlite

# download symfony demo and build it
FROM base as composer

RUN apk add --no-cache \
    git \
    composer \
    unzip \
    php-frankenphp-8.3 \
    php-frankenphp-8.3-curl \
    php-frankenphp-8.3-openssl \
    php-frankenphp-8.3-phar

WORKDIR /app
RUN git clone https://github.com/symfony/demo.git --depth=1 .
RUN composer install
RUN bin/console asset-map:compile
RUN rm -rf .git

# build final image

FROM base

COPY --from=composer /app /app