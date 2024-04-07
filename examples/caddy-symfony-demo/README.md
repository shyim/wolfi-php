# Symfony Demo with Caddy

This is a Dockerfile to set up a Symfony Demo application with Caddy.

This example is using this [Caddy image](../../images/caddy/).

```bash
docker build -t symfony-demo .
docker run -p 8000:8000 symfony-demo
```

and then open http://localhost:8000 in your browser.
