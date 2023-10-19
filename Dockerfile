FROM debian:bookworm-slim AS builder
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get install -y apt-utils
COPY ./betternginx /opt/betternginx

RUN sh /opt/betternginx/build.sh

FROM debian:bookworm-slim
COPY --from=builder /opt/betternginx/betternginxdebian.deb /opt/betternginxdebian.deb

RUN apt-get install -y /opt/betternginxdebian.deb && rm -f /opt/betternginxdebian.deb && mkdir -p /var/cache/nginx && chown -R nginx:nginx /var/cache/nginx
    
EXPOSE 80 443
STOPSIGNAL SIGTERM

RUN nginx -V
CMD ["nginx", "-g", "daemon off;"]