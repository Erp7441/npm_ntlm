**npm_ntlm**

[Nginx proxy manager](https://github.com/NginxProxyManager/nginx-proxy-manager) with integrated [NTML module](https://github.com/gabihodoroaga/nginx-ntlm-module).

**Build locally**
```bash
docker buildx build -t erp7441/npm_ntlm:local .
```

**Updating NGINX version**
Argument NGINX_VERSION should always match [Nginx proxy manager](https://github.com/NginxProxyManager/nginx-proxy-manager) current version.
