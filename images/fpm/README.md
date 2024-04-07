# FPM only image

## Image information

- Build for PHP 8.2 and 8.3
- Build for amd64/arm64
- Pretty small with just PHP-FPM installed

## Usage

```dockerfile
FROM ghcr.io/shyim/wolfi-php/fpm:8.3

# Install missing extensions
RUN apk add --no-cache php-8.3-redis php-8.3-gd

# Copy your files
COPY . /var/www/html
```

> [!IMPORTANT]
> When you use only FPM, you will need a webserver like Caddy/Nginx to serve HTTP requests and proxy them to PHP-FPM.

## Available environment variables

The image has some environment variables to configure PHP-FPM or PHP. This should cover all common use cases.

### FPM

- `PHP_FPM_USER` - FPM is running as this user (default: www-data)
- `PHP_FPM_GROUP` - FPM is running as this group (default: www-data)
- `PHP_FPM_LISTEN` - FPM listen address (default: :9000)
- `PHP_FPM_PM` - FPM process manager (default: dynamic)
- `PHP_FPM_PM_MAX_CHILDREN` - FPM max children (default: 5)
- `PHP_FPM_PM_START_SERVERS` - FPM start servers (default: 2)
- `PHP_FPM_PM_MIN_SPARE_SERVERS` - FPM min spare servers (default: 1)
- `PHP_FPM_PM_MAX_SPARE_SERVERS` - FPM max spare servers (default: 3)
- `PHP_FPM_PM_MAX_REQUESTS` - FPM max requests (default: 500)

These FPM settings are the default one from PHP, you may want to change them based on your available resources and application. 

### PHP

- `PHP_ERROR_REPORTING` - PHP error reporting (default: "")
- `PHP_DISPLAY_ERRORS` - PHP display errors (default: On)
- `PHP_DISPLAY_STARTUP_ERRORS` - PHP display startup errors (default: On)
- `PHP_UPLOAD_MAX_FILESIZE` - PHP upload max filesize (default: 2M)
- `PHP_POST_MAX_SIZE` - PHP post max size (default: 8M)
- `PHP_MAX_EXECUTION_TIME` - PHP max execution time (default: 30)
- `PHP_MEMORY_LIMIT` - PHP memory limit (default: 128M)
- `PHP_SESSION_HANDLER` - PHP session handler (default: files)
- `PHP_SESSION_SAVE_PATH` - PHP session save path (default: "")
- `PHP_SESSION_GC_PROBABILITY` - PHP session gc probability (default: 1)

These PHP settings are the default one from PHP, you may want to change them based on your application requirements.

### Changing those variables

You can configure them before starting your container:

```shell
docker run \
    --rm \
    -e PHP_MEMORY_LIMIT=256M \
    your-image
```

or in your Dockerfile:

```dockerfile
FROM ghcr.io/shyim/wolfi-php/fpm:8.3

ENV PHP_MEMORY_LIMIT=256M
```

### Using Redis session

To use Redis as session handler, you need to install the Redis extension and set the session handler to redis:

```dockerfile
FROM ghcr.io/shyim/wolfi-php/fpm:8.3

RUN apk add --no-cache php-8.3-redis

# Set session handler to redis
ENV PHP_SESSION_HANDLER=redis \
    PHP_SESSION_SAVE_PATH=tcp://redis:6379
```

## Adding custom PHP/FPM configuration

To add custom PHP, create a file `/etc/php/conf.d/zz-custom.ini` and add your configuration there:

```dockerfile
FROM ghcr.io/shyim/wolfi-php/fpm:8.3

COPY custom.ini /etc/php/conf.d/zz-custom.ini
```

for FPM you can do the same with the path `/etc/php/php-fpm.d/zz-custom.conf`:

```dockerfile
FROM ghcr.io/shyim/wolfi-php/fpm:8.3

COPY custom.conf /etc/php/php-fpm.d/zz-custom.conf
```

## Running as non-root

The image is running as root by default. You can just need to switch the USER in the Dockerfile:

```dockerfile
USER www-data
```

If you want to use a custom user, you don't need to change the configuration. When PHP-FPM is started as a non-root user, the user and group configuration is automatically set to the user you are running PHP-FPM as.
