# FPM

This example uses two containers to run a Symfony application with PHP-FPM and Nginx.

The base fpm is can be [found here](../../images/fpm).

We build in the `Dockerfile` the PHP-FPM container and setup a small nginx container.

The traffic is as follows:

```
Browser -> Nginx -> PHP-FPM
```
