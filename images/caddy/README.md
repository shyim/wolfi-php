# Caddy + PHP-FPM

This image contains caddy and PHP-FPM in the same container. To run both processes in the same container, we use hivemind, a Procfile compatible process manager.

## Usage

```dockerfile
FROM ghcr.io/shyim/wolfi-php/caddy:8.3

# Install missing extensions
RUN apk add --no-cache php-8.3-redis php-8.3-gd

# Copy your files
COPY . /var/www/html
```

```shell
docker build -t my-image .
docker run -p 8000:8000 my-image
```

You can run it for testing purposes also directly, `docker run --rm -p 8000:8000 ghcr.io/shyim/wolfi-php/caddy:8.3` and you should see at `http://localhost:8000` the php info page.

## PHP Extensions / PHP Configuration

As this image bases on [fpm](../fpm/), you can check out there how to configure PHP / PHP-FPM and install php extensions.

## Caddy Configuration

- `SERVER_NAME` - The server name for Caddy. Default is `:8000` - This controls also the listing port of Caddy, use `:8000` as example for port `8000`
- `CADDY_GLOBAL_OPTIONS` - Allows setting global options for Caddy like: `debug`
- `CADDY_EXTRA_CONFIG` - Allows setting extra Caddy configuration like add new virtual host: `foo.com { root /app/public }`
- `CADDY_SERVER_EXTRA_DIRECTIVES` - Allows setting extra Caddy configuration for the default virtual host. [See here for all options](https://caddyserver.com/docs/caddyfile/directives)

## Overwrite Caddy Configuration

You can overwrite the Nginx configuration by copying your own configuration to `/etc/caddy/Caddyfile`:

```dockerfile
COPY Caddyfile /etc/caddy/Caddyfile
```

You can find the default configuration [here](./rootfs/etc/caddy/Caddyfile).

## Running rootless

You can run the container as a non-root user. The image has a user `www-data` with UID 82. You can use it like this:

```dockerfile
USER www-data
```
