# Apache Upgrade with HTTP/2 + Brotli Installation (CWP / AlmaLinux 9)

![Apache](https://img.shields.io/badge/Apache-2.4.65-red?logo=apache)
![HTTP/2](https://img.shields.io/badge/HTTP%2F2-Enabled-blue)
![Brotli](https://img.shields.io/badge/Brotli-Compression-green)
![OS](https://img.shields.io/badge/EL9-AlmaLinux%209%20%2F%20RHEL%209-lightgrey)
![CWP](https://img.shields.io/badge/CWP-Compatible-orange)
![Automated Install](https://img.shields.io/badge/Install-Automated-success?logo=gnubash&logoColor=white)
![License](https://img.shields.io/badge/License-GPLv3-blue.svg)



This script provides a **safe production-ready rebuild of Apache HTTP Server** with:

- Upgrades Apache to **2.4.65**
- **HTTP/2** support (mod_http2)
- **Brotli** compression (mod_brotli)
- Updated APR & APR-Util
- Compatibility with **Control Web Panel (CWP)** on **EL9** systems



## 🚀 Features

- Apache **2.4.65** clean build from source
- HTTP/2 enabled (`h2`, `h2c`)
- Brotli compression enabled (level 6)
- Automatically installs required dependencies
- Includes updated APR / APR-Util libraries
- Backup and rollback support
- Minimal configuration changes to existing CWP setup
- Safe restart with config validation

  

## ⚙️ Requirements

- OS: **AlmaLinux 9 / RHEL 9 / compatible EL9 systems**
- Control Web Panel (CWP): **0.9.8.1224 or later**
- Root access



## ❌ Known Limitations

- Not compatible with **mod_security** (must be removed before running)
- Overwrites Apache build under `/usr/local/apache`
- Requires systemd-managed Apache (`httpd` service)



## 📦 Installation

### 1. Remove mod_security (if installed)

### 2. Download the script
```
wget https://your-repo-link/install-httpd-http2-brotli.sh
```
### 3. Make it executable
```
chmod +x install-httpd-http2-brotli.sh
```
### 4. Run the script
```
./install-httpd-http2-brotli.sh
```



## 🔧 What the Script Does


### Step 1: Installs Dependencies

Installs required build tools and libraries:

- gcc / gcc-c++
- make / cmake
- pcre-devel
- openssl-devel
- brotli + nghttp2
- libxml2-devel


### Step 2: Backup Existing Apache

Creates a full backup before modification:
```
/usr/local/apache.backup.YYYYMMDD_HHMMSS
```


### Step 3: Downloads Apache Source

- Apache HTTP Server 2.4.65  
- Extracts and prepares source tree


### Step 4: Updates APR Libraries

- APR 1.7.4  
- APR-Util 1.6.3  

These are embedded inside Apache build for stability.


### Step 5: Compiles Apache with Features

Enabled modules:

- mod_ssl
- mod_rewrite
- mod_deflate
- mod_http2
- mod_brotli
- mod_proxy
- mod_headers
- mod_expires
- mod_userdir
- mod_suexec



## 🌐 HTTP/2 Configuration

Automatically creates:
/usr/local/apache/conf.d/http2.conf
```
Protocols h2 h2c http/1.1
```


## 🧊 Brotli Configuration

Automatically creates:
```
/usr/local/apache/conf.d/brotli.conf
```
Features:

- Compression level: 6
- Smart MIME filtering
- Disables compression for images/fonts
- Adds proper Vary header


## 📁 Backup Location

Backup is stored at:
```
/usr/local/apache.backup.YYYYMMDD_HHMMSS
```



## ⚠️ Important Notes
- Apache version is currently hardcoded (2.4.65)
- APR versions are also fixed (can be parameterized later)
- Designed for CWP environments only
- Always test on staging before production use


## 🔮 Future Improvements

Planned enhancements:

- Version variables for Apache / APR / APR-Util

---

## 👨‍💻 Author

Maintained by Mehroz Anjum
