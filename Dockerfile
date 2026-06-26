ARG NGINX_VERSION=1.29.8
FROM debian:bookworm-slim AS builder

ARG NGINX_VERSION
WORKDIR /build

# Install build deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential ca-certificates wget git libpcre3-dev zlib1g-dev libssl-dev \
 && rm -rf /var/lib/apt/lists/*

# Download nginx source matching your nginx version
RUN wget -O nginx.tar.gz "https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" \
 && tar xzf nginx.tar.gz

# Grab the NTLM module source
RUN git clone --depth 1 https://github.com/gabihodoroaga/nginx-ntlm-module.git /build/nginx-ntlm-module

WORKDIR /build/nginx-${NGINX_VERSION}

# Configure to build a dynamic module (with compatibility)
RUN ./configure \
    --with-compat \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_realip_module \
    --with-http_gzip_static_module \
    --add-dynamic-module=/build/nginx-ntlm-module

# Build only modules (faster)
RUN make -j"$(nproc)" modules

# Collect the compiled module
RUN mkdir -p /out && cp objs/ngx_http_upstream_ntlm_module.so /out/

FROM jc21/nginx-proxy-manager:latest AS final

# Copy the compiled module into an nginx modules directory
COPY --from=builder /out/ngx_http_upstream_ntlm_module.so /etc/nginx/modules/ngx_http_upstream_ntlm_module.so

# Ensure the modules folder exists and set ownership
RUN mkdir -p /etc/nginx/modules && chown -R root:root /etc/nginx/modules

# Modify nginx.conf to load the module
RUN set -eux; \
    if [ -f /etc/nginx/nginx.conf ]; then \
      grep -q "ngx_http_upstream_ntlm_module" /etc/nginx/nginx.conf || \
      sed -i '1iload_module "/etc/nginx/modules/ngx_http_upstream_ntlm_module.so";\' /etc/nginx/nginx.conf; \
    fi
