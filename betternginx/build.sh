#!/bin/sh
cd /opt/betternginx
apt-get update
apt-get install -y git build-essential brotli libbrotli-dev libpcre2-dev libpcre3-dev libpcre3 zlib1g-dev zlib1g
git clone --recursive --depth 1 --branch release-1.27.4 https://github.com/nginx/nginx.git
git clone --recursive --depth 1 https://github.com/quictls/openssl.git
git clone --recursive --depth 1 https://github.com/google/ngx_brotli.git
git clone --recursive --depth 1 https://github.com/openresty/headers-more-nginx-module.git
cd nginx
./auto/configure \
--with-http_v3_module \
--with-http_v2_module \
--with-cc-opt="-I.../openssl/build/include" \
--with-ld-opt="-L.../openssl/build/lib" \
--with-openssl=../openssl \
--with-openssl-opt=enable-ktls \
--add-module=../ngx_brotli \
--add-module=../headers-more-nginx-module \
--prefix=/etc/nginx \
--sbin-path=/usr/sbin/nginx \
--modules-path=/usr/lib/nginx/modules \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/logs/main-error.log \
--http-log-path=/logs/main-access.log \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/run/nginx.lock \
--http-client-body-temp-path=/var/cache/nginx/client_temp \
--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
--user=nginx \
--group=nginx \
--with-file-aio \
--with-threads \
--with-http_addition_module \
--with-http_auth_request_module \
--with-http_dav_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_mp4_module \
--with-http_random_index_module \
--with-http_realip_module \
--with-http_secure_link_module \
--with-http_slice_module \
--with-http_ssl_module \
--with-http_stub_status_module \
--with-http_sub_module \
--with-mail \
--with-mail_ssl_module \
--with-stream \
--with-stream_realip_module \
--with-stream_ssl_module \
--with-stream_ssl_preread_module -\
-with-cc-opt='-g -O3 -flto -march=x86-64-v2 -ffile-prefix-map=/data/builder/debuild/nginx/debian/debuild-base/nginx=. -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' \
--with-ld-opt='-Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie'
make
cd ../
mv ./nginx/objs/nginx ./betternginxdebian/usr/sbin/nginx
chmod +x ./betternginxdebian/usr/sbin/nginx
dpkg-deb --root-owner-group --build betternginxdebian
mv ./betternginxdebian.deb /betternginxdebian.deb
