# Nginx proxy manager with integrated NTLM module

[Nginx proxy manager](https://github.com/NginxProxyManager/nginx-proxy-manager) with integrated [NTML module](https://github.com/gabihodoroaga/nginx-ntlm-module).

Built image is available on [DockerHub](https://hub.docker.com/r/erp7441/npm_ntlm) 

**Build locally**
```bash
docker buildx build -t erp7441/npm_ntlm:local .
```

**Updating NGINX version**
Argument NGINX_VERSION should always match [Nginx proxy manager](https://github.com/NginxProxyManager/nginx-proxy-manager) current version.
