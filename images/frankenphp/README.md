# FrankenPHP

We provide also a replacement like the official FrankenPHP image same Caddyfile, but with Wolfi.

## Usage example

```dockerfile
# 8.2 is also available
FROM ghcr.io/shyim/wolfi-php/frankenphp:8.3

# copy source code to /app/public
COPY . /app/public
```

```bash
docker build -t my-image .
docker run --rm -p 80:80 -p 443:443 my-image
```

## Disabling HTTPS

If you want to disable HTTPS, you can use the following environment variable:

```bash
docker run \
    --rm \
    -e SERVER_NAME=:80 \
    -p 80:80 my-image
```

## Available environment variables

- `SERVER_NAME` - The server name for Caddy. Default is `localhost` - This controls also the listing port of Caddy, use `:8000` as example for port `8000`
- `FRANKENPHP_CONFIG` - Allows to set configuration for FrankenPHP specific like: `worker ./public/index.php`
- `CADDY_GLOBAL_OPTIONS` - Allows to set global options for Caddy like: `debug`
- `CADDY_EXTRA_CONFIG` - Allows to set extra Caddy configuration like add new virtual host: `foo.com { root /app/public }`
- `CADDY_SERVER_EXTRA_DIRECTIVES` - Allows to set extra Caddy configuration for the default virtual host. [See here for all options](https://caddyserver.com/docs/caddyfile/directives)

## Rootless

To run the container, as a non-root user, you can do the following:

```dockerfile
FROM ghcr.io/shyim/wolfi-php/frankenphp:8.3

ARG USER=www-data

RUN \
    mkdir -p /data/caddy && mkdir -p /config/caddy; \
    apk add --no-cache libcap-utils; \
	adduser -D ${USER}; \
	# Add additional capability to bind to port 80 and 443
	setcap CAP_NET_BIND_SERVICE=+eip /usr/bin/frankenphp; \
	# Give write access to /data/caddy and /config/caddy
	chown -R ${USER}:${USER} /data/caddy && chown -R ${USER}:${USER} /config/caddy; \
    apk del libcap-utils

USER ${USER}
```

## Installing extensions

To install PHP extensions, you can use the `apk` package manager. For example, to install the `gd` extension, you can run:

```dockerfile
# pick one of these
FROM ghcr.io/shyim/wolfi-php/base:latest
# frankenphp one, bases on the base image
FROM ghcr.io/shyim/wolfi-php/frankenphp:8.3

RUN apk add --no-cache php-frankenphp-8.3-gd
```

It's important that you only install extensions matching to your PHP version and with the `php-frankenphp` prefix.
