FROM debian:sid-slim AS builder
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get install -y apt-utils
COPY ./betternginx /opt/betternginx
RUN sh /opt/betternginx/build.sh

# Copy main config
COPY nginx.conf /etc/nginx/nginx.conf

# Fix nginx log permissions
RUN chown -R nginx:nginx /var/log/nginx; && chmod -R 755 /var/log/nginx;

EXPOSE 80 443
STOPSIGNAL SIGTERM

RUN nginx -V
CMD ["nginx", "-g", "daemon off;"]
