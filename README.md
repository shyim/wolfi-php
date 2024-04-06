# Wolfi-OS PHP Repository

This Repository contains popular PHP extensions pre-compiled to be used in Wolfi-OS. [I am trying to upstream all packages to the official repository](https://github.com/wolfi-dev/os/pulls?q=+is%3Apr+author%3Ashyim+).
The packages are all built for x86_64 and aarch64. A GitHub bot is automatically updating the packages and opens a new PR if a new version is available.

## Installation of Repository

<details>
  <summary>with Dockerfile</summary>

```docker
FROM cgr.dev/chainguard/wolfi-base

RUN echo "https://wolfi.shyim.me" >> /etc/apk/repositories && \
cat <<EOF > /etc/apk/keys/php-signing.rsa.pub
-----BEGIN PUBLIC KEY-----
MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA9s0rytmiqI5l6IgwLqiD
ecg3jwDIHWfzVmzfedTen4KW5MkmUVXgFXbmegD/e4arNzqkw2tpqIkYgKO4G5MF
wMvfvx4NP/dDBmEwRkqiq53+TfiaLZQYpotZy1Zrb7GHQBIQ+hK1ekN+WFBOmhd5
fwdPPBLbG1aOjigyydLdriLCDOf7mo7OZq7K42Ima2/Mp/Cdb12JswxIc5XYuJwX
35grsQy7dcli7QUbh20f/teB0hMb70V9RanXf2I8lzZ74djHMlDk6lJ0blBA8Wzl
P0m+yznoGIcSvix18XO78/TlbEajH/m8w4mjrNsgzeRlMeexOz0JO6fn7FtcRh3X
QmgAQ5QRy3ioZ1haEdr+oLlEOGUlmG1xdnpRCPAb8L0Xu7qDJr8Sm7DKPpzM5Jc4
k8/WCHJzsmOYPSV83itxTk6hfiMY5L/IsJsOe9/ZzUxmpiLEY5NSjiS+jSu/I492
PePYfiX/on7GNEzbRRaQzQ9cwKSKswpXxkk8dPQUTDPZ4SGclJzE0Yle/utQ4AJM
vMYK/ceaMC56CvEfoUmH3o2H0Y8MRhEE0hQ7xmIWlTfgJx256ToXG3auNVWs2Ax2
cwcAYarHaBAYoljBMyCqMWW+7nLCXoI0bAb0O4f2X2I6zpD2MsE7obLQA6l6x/X+
og/rYbYh7rDgqPyhAU8tJicCAwEAAQ==
-----END PUBLIC KEY-----
EOF

RUN ...
```

</details>


<details>
  <summary>with apko</summary>

[apko](https://github.com/chainguard-dev/apko)

```diff
contents:
  keyring:
    - https://packages.wolfi.dev/os/wolfi-signing.rsa.pub
+    - https://wolfi.shyim.me/php-signing.rsa.pub
  repositories:
    - https://packages.wolfi.dev/os
+    - https://wolfi.shyim.me
  packages:
    - wolfi-base
    - frankenphp-8.3
```

</details>

afterwards all packages of this repository can be installed with `apk add <package>` or apko.

## Available Packages

There is no web package browser. The easiest way is to use `apk search` to find the package you need.

```bash
docker run --rm -it ghcr.io/shyim/wolfi-php/base:latest
apk update
apk search <term>
```

## FrankenPHP

This repository contains FrankenPHP for PHP 8.2 and 8.3. The package is called `frankenphp-8.2` and `frankenphp-8.3`.

A basic example to use FrankenPHP in your Dockerfile:

```dockerfile
FROM ghcr.io/shyim/wolfi-php/base:latest

RUN <<EOF
set -eo pipefail
apk add --no-cache \
    frankenphp-8.2 \
    php-frankenphp-8.2
adduser -u 82 www-data -D
EOF

WORKDIR /var/www/html
USER www-data
EXPOSE 8000

ENTRYPOINT [ "/usr/bin/frankenphp", "run" ]
CMD [ "--config", "/etc/caddy/Caddyfile" ]
```

After building the image, you can run the container with `docker run -p 8000:8000 <image>` and it should show a PHP info page.

### "Drop-in" replacement for official FrankenPHP image

We provide also a replacement like the official FrankenPHP image same Caddyfile, but with Wolfi.

```dockerfile
# 8.2 is also available
FROM ghcr.io/shyim/wolfi-php/frankenphp:8.3

# copy source code to /app/public
COPY . /app/public
```

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

### Installing extensions

To install PHP extensions, you can use the `apk` package manager. For example, to install the `gd` extension, you can run:

```dockerfile
# pick one of these
FROM ghcr.io/shyim/wolfi-php/base:latest
# frankenphp one, bases on the base image
FROM ghcr.io/shyim/wolfi-php/frankenphp:8.3


RUN apk add --no-cache php-frankenphp-8.3-gd
```

It's important that you only install extensions matching to your PHP version and with the `php-frankenphp` prefix.


## Examples

- [Symfony Demo with FrankenPHP](examples/frankenphp-symfony-demo/README.md)
- [FPM](examples/fpm/README.md)
