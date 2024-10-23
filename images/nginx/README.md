# Nginx + PHP-FPM

This image contains Nginx and PHP-FPM in the same container. To run both processes in the same container, we use hivemind, a Procfile compatible process manager.

## Usage

```dockerfile
FROM ghcr.io/shyim/wolfi-php/nginx:8.3

# Install missing extensions
RUN apk add --no-cache php-8.3-redis php-8.3-gd

# Copy your files
COPY . /var/www/html
```

```shell
docker build -t my-image .
docker run -p 8080:8080 my-image
```

You can run it for testing purposes also directly, `docker run --rm -p 8080:8080 ghcr.io/shyim/wolfi-php/nginx:8.3` and you should see at `http://localhost:8000` the php info page.

## PHP Extensions / PHP Configuration

As this image bases on [fpm](../fpm/), you can check out there how to configure PHP / PHP-FPM and install php extensions.

## Overwrite Nginx Configuration

You can overwrite the Nginx configuration by copying your own configuration to `/etc/nginx/nginx.conf`:

```dockerfile
COPY nginx.conf /etc/nginx/nginx.conf
```

You can find the default configuration [here](./rootfs/etc/nginx/nginx.conf).

## Running rootless

You can run the container as a non-root user. The image has a user `www-data` with UID 82. You can use it like this:

```dockerfile
USER www-data
```
