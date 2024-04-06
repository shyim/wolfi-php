# NGINX + PHP-FPM

This example shows how to run a PHP-FPM server with Nginx inside the same container. To start both processes, we use overmind which is a Procfile-based process manager.

For optimal performance, php-fpm and nginx are only talking with each other via unix sockets.