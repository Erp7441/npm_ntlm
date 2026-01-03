FROM docker.io/jc21/nginx-proxy-manager:latest

COPY 50-ntlm.conf /etc/nginx/conf.d/50-ntlm.conf

ARG NGINX_NTLM_URL="https://extras.getpagespeed.com/debian/pool/main/n/nginx-module-ntlm/nginx-module-ntlm_1.28.0-6~gps1%2Bdeb12%2Bstable_amd64.deb"
ARG IGNORE_DEPS="nginx-r1.28.0"

RUN curl --output nginx-module-ntlm.deb $NGINX_NTLM_URL && \
    dpkg -i --ignore-depends=$IGNORE_DEPS nginx-module-ntlm.deb && \
    rm nginx-module-ntlm.deb
