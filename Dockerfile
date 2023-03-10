FROM debian:sid-slim AS builder
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get install -y apt-utils
COPY ./betternginx /opt/betternginx

RUN sh /opt/betternginx/build.sh

# Copy main config
COPY nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /logs && chown -R nginx:nginx /logs && \
    mkdir -p /var/cache/nginx && chown -R nginx:nginx /var/cache/nginx
    
EXPOSE 80 443
STOPSIGNAL SIGTERM

RUN nginx -V
CMD ["nginx", "-g", "daemon off;"]
