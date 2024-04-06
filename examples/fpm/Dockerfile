FROM ghcr.io/shyim/wolfi-php/base:latest

RUN <<EOF
apk add --no-cache \
    php-8.3 \
    php-8.3-fpm 
adduser -u 82 www-data -D
mkdir -p /var/www/html
EOF

WORKDIR /var/www/html
USER www-data
EXPOSE 9000
    
ENTRYPOINT [ "/usr/sbin/php-fpm" ]
