# Apache Upgrade with HTTP/2 support and Brotli Compression for AlmaLinux 9

Use this script to update your Control Web Panel (CWP) Apache version to 2.4.65

# Features

Works with EL9 (Tested)

Installs & Enables HTTP/2 with latest apr and apr-utils

Installs and Enables Brotli (sets compression level to 6)

Minimal modification

# Requirements

OS: EL9

CWP Version: 0.9.8.1224

# Doesn't Work With

Mod Security

# How To Use

Uninstall mod_security before proceeding download the script

chmod +x install-httpd-http2-brotli.sh

./install-httpd-http2-brotli.sh

# Consideration

Right now version numbers are hardcoded which will converted to variables to fetch desired Apache version

