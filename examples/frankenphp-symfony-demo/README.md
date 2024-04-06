# Symfony Demo with FrankenPHP

This is a Dockerfile to set up a Symfony Demo application with FrankenPHP.

```bash
docker build -t symfony-demo .
docker run -p 80:80 -e SERVER_NAME=http://localhost symfony-demo
```

and then open http://localhost in your browser.