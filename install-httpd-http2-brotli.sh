#!/bin/bash

# ==========================================================
# Script Name : install-httpd-http2-brotli.sh
# Description  : Apache 2.4.65 build with HTTP/2 + Brotli
#               (CWP SAFE BUILD - Production Ready)
# Author       : Mehroz Anjum
# Date         : 2026-04-11
# ==========================================================

set -e

# ----------------------------------------------------------
# Color Codes
# ----------------------------------------------------------
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=== Apache CLEAN BUILD START ===${NC}"

# ----------------------------------------------------------
# 1. Install Required Dependencies
# ----------------------------------------------------------
echo -e "${YELLOW}[1/5] Installing dependencies...${NC}"

dnf -y install gcc gcc-c++ make wget curl pcre-devel cmake git \
libxml2-devel curl-devel brotli brotli-devel libnghttp2 libnghttp2-devel \
openssl-devel

# ----------------------------------------------------------
# 2. Backup Existing Apache Installation
# ----------------------------------------------------------
echo -e "${YELLOW}[2/5] Backing up Apache...${NC}"

BACKUP_DIR="/usr/local/apache.backup.$(date +%Y%m%d_%H%M%S)"
cp -r /usr/local/apache "$BACKUP_DIR"
echo "Backup saved at: $BACKUP_DIR"

# ----------------------------------------------------------
# 3. Download Apache Source Code
# ----------------------------------------------------------
echo -e "${YELLOW}[3/5] Downloading Apache 2.4.65...${NC}"

cd /usr/local/src
rm -rf httpd-2.4.65
wget https://archive.apache.org/dist/httpd/httpd-2.4.65.tar.gz
tar xzf httpd-2.4.65.tar.gz
cd httpd-2.4.65

# ----------------------------------------------------------
# 4. Add APR / APR-UTIL (Required for build)
# ----------------------------------------------------------
echo -e "${YELLOW}[4/5] Adding APR libraries...${NC}"

cd srclib
rm -rf apr apr-util

wget https://archive.apache.org/dist/apr/apr-1.7.4.tar.gz
tar xf apr-1.7.4.tar.gz
mv apr-1.7.4 apr

wget https://archive.apache.org/dist/apr/apr-util-1.6.3.tar.gz
tar xf apr-util-1.6.3.tar.gz
mv apr-util-1.6.3 apr-util

cd ..

# ----------------------------------------------------------
# 5. Configure, Build and Install Apache
# ----------------------------------------------------------
echo -e "${YELLOW}[5/5] Configuring and compiling Apache...${NC}"

./configure \
--enable-so \
--prefix=/usr/local/apache \
--enable-ssl \
--enable-rewrite \
--enable-deflate \
--enable-suexec \
--with-suexec-docroot="/home" \
--with-suexec-caller="nobody" \
--with-suexec-logfile="/usr/local/apache/logs/suexec_log" \
--enable-asis \
--enable-filter \
--with-pcre \
--enable-headers \
--enable-expires \
--enable-proxy \
--enable-userdir \
--enable-http2 \
--enable-brotli \
--with-brotli=/usr \
--with-included-apr

make -j$(nproc)
make install

# ----------------------------------------------------------
# Apache Module Configuration
# ----------------------------------------------------------

echo -e "${YELLOW}Configuring HTTP/2 and Brotli modules...${NC}"

cat > /usr/local/apache/conf.d/http2.conf <<EOF
LoadModule http2_module modules/mod_http2.so
Protocols h2 h2c http/1.1
EOF

cat > /usr/local/apache/conf.d/brotli.conf <<EOF
LoadModule brotli_module modules/mod_brotli.so

<IfModule mod_brotli.c>
    BrotliCompressionQuality 6

    AddOutputFilterByType BROTLI_COMPRESS \
    text/html text/plain text/xml text/css \
    text/javascript application/javascript application/json

    SetEnvIfNoCase Request_URI \.(gif|jpg|jpeg|png|webp|woff|woff2)$ no-brotli
    Header append Vary User-Agent env=!dont-vary
</IfModule>
EOF

# Ensure Apache includes conf.d directory
grep -q "conf.d/\*.conf" /usr/local/apache/conf/httpd.conf || \
echo "IncludeOptional conf.d/*.conf" >> /usr/local/apache/conf/httpd.conf

# ----------------------------------------------------------
# Restart Apache Safely
# ----------------------------------------------------------

echo -e "${YELLOW}Testing Apache configuration...${NC}"

if /usr/local/apache/bin/apachectl configtest; then
    systemctl restart httpd
    echo -e "${GREEN}SUCCESS: Apache restarted successfully${NC}"
else
    echo -e "${RED}ERROR: Configuration failed, restoring backup...${NC}"
    systemctl stop httpd
    rm -rf /usr/local/apache
    cp -r "$BACKUP_DIR" /usr/local/apache
    systemctl start httpd
    exit 1
fi

# ----------------------------------------------------------
# Verification
# ----------------------------------------------------------

echo -e "${GREEN}Loaded Modules:${NC}"
/usr/local/apache/bin/apachectl -M | grep -E "http2|brotli" || true

echo -e "${GREEN}=== BUILD COMPLETE ===${NC}"
echo "Backup location: $BACKUP_DIR"
