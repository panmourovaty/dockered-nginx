FROM debian:sid-slim AS builder
RUN apt-get update && apt-get dist-upgrade -y
COPY ./betternginx /opt/betternginx
RUN sh /opt/betternginx/build.sh

# Copy main config
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443
STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
