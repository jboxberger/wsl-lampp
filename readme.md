**WSL (Windows Subsystem for Linux) LAMPP Installer**

Automated LAMPP installer for the LAMPP Windows Subsystem for Linux. You can choose the modules you need during the installation.
- Apache 2
- PHP 7.0
  - php7.0-mcrypt 
  - php7.0-mysql 
  - php7.0-soap 
  - php7.0-curl 
  - php7.0-gd 
  - php-imagick 
  - php7.0-imap 
  - php7.0-xmlrpc 
  - php7.0-xsl 
  - php7.0-mbstring
  - php-xdebug
- MySql
- PhpMyAdmin
- SSH Daemon

**Supported Windows Versions:**
- Windows 10 Version 1703 Build 15063
- Windows 10 Version 1709 Build 16299 - Fall Creators Update

I highly recommend to install the Build 16299 (Fall Creators Update). This improves the WSL performance significantly.

The WSL filesystem can be accessed over the Windows filesystem under the following path: 
C:\Users\<user>\AppData\Local\lxss\rootfs

<b>wsl-install.bat:</b> checks windows requirements and installs the WSL<br />
<b>wsl-install-lampp.bat:</b> installs required lampp packages<br />
<b>wsl-autostart.sh:</b> starts installed daemons (apache2, mysql, ssh) on bash open<br />

License: GNU GPLv3
