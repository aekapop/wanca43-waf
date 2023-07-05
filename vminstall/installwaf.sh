#!/bin/bash
# Update OS
apt update && apt upgrade -y
# Install Library and Tools
apt install g++ flex bison curl apache2-dev doxygen libyajl-dev ssdeep liblua5.2-dev libgeoip-dev libtool dh-autoreconf libcurl4-gnutls-dev libxml2 libpcre++-dev libxml2-dev git liblmdb-dev libpkgconf3 lmdb-doc pkgconf zlib1g-dev libssl-dev -y
# Download modsecurity and unzip
wget https://github.com/SpiderLabs/ModSecurity/releases/download/v3.0.9/modsecurity-v3.0.9.tar.gz && tar -zxvf modsecurity-v3.0.9.tar.gz && rm modsecurity-v3.0.9.tar.gz
# Download modsecurity module for nginx and unzip
wget https://github.com/SpiderLabs/ModSecurity-nginx/releases/download/v1.0.3/modsecurity-nginx-v1.0.3.tar.gz && tar -zxvf modsecurity-nginx-v1.0.3.tar.gz && rm modsecurity-nginx-v1.0.3.tar.gz
# Download nginx for make proxy and unzip 
wget http://nginx.org/download/nginx-1.24.0.tar.gz && tar -zxvf nginx-1.24.0.tar.gz && rm nginx-1.24.0.tar.gz
# Install ModSecurity
cd modsecurity-v3.0.9/
./build.sh >> /dev/null 2>&1
./configure && make && make install
cd ..
# Install Nginx
useradd -r -M -s /sbin/nologin -d /usr/local/nginx nginx
cd nginx-1.24.0/
./configure --user=nginx --group=nginx --with-pcre-jit --with-debug --with-compat --with-http_ssl_module --with-http_realip_module --add-dynamic-module=../modsecurity-nginx-v1.0.3 --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log
make && make modules && make install
ln -s /usr/local/nginx/sbin/nginx /usr/local/sbin/
# Test nginx
nginx -V
cd ..
# Install CRS
git clone https://github.com/SpiderLabs/owasp-modsecurity-crs.git /usr/local/nginx/conf/owasp-crs
cp modsecurity-v3.0.9/modsecurity.conf-recommended /usr/local/nginx/conf/modsecurity.conf
cp modsecurity-v3.0.9/unicode.mapping /usr/local/nginx/conf/
cp /usr/local/nginx/conf/nginx.conf{,.bak}
cp nginx.conf /usr/local/nginx/conf/nginx.conf
sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /usr/local/nginx/conf/modsecurity.conf
cp nginx.service /etc/systemd/system/nginx.service
# Set Auto Start Nginx
systemctl daemon-reload
systemctl start nginx
systemctl enable nginx
systemctl status nginx
