FROM ghcr.io/shyim/wolfi-php/base:latest

ARG PHP_VERSION=8.2

RUN <<EOF
set -eo pipefail
apk add --no-cache \
    curl \
    frankenphp-${PHP_VERSION}
EOF

COPY Caddyfile /etc/caddy/Caddyfile

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

EXPOSE 80
EXPOSE 443
EXPOSE 443/udp
EXPOSE 2019

LABEL org.opencontainers.image.title=FrankenPHP
LABEL org.opencontainers.image.description="The modern PHP app server"
LABEL org.opencontainers.image.url=https://frankenphp.dev
LABEL org.opencontainers.image.source=https://github.com/shyim/wolfi-php
LABEL org.opencontainers.image.licenses=MIT
LABEL org.opencontainers.image.vendor="Shyim"

WORKDIR /app
EXPOSE 8000
    
ENTRYPOINT [ "/usr/bin/frankenphp", "run" ]
CMD [ "--config", "/etc/caddy/Caddyfile" ]
HEALTHCHECK CMD curl -f http://localhost:2019/metrics || exit 1
