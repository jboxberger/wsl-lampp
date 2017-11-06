**WSL (Windows Subsystem for Linux) LAMPP Installer**

Automated LAMPP installer for the LAMPP Windows Subsystem for Linux. You can choose the modules you need during the installation.

- Apache 2
- PHP 7.0
  - php7.0-mcrypt 
  - php7.0-mysql 
  - php7.0-soap 
  - php7.0-curl 
  - php7.0-gd 
  - php7.0-imap 
  - php7.0-xmlrpc 
  - php7.0-xsl 
  - php7.0-mbstring
  - php-imagick
  - php-xdebug
- MySQL
- PhpMyAdmin
- SSH Daemon

Please note, the WSL and the services are only running while the bash window is open. Closing the bash is equivalent to shutdown the system. Reboot is not impemented in the WSL, just close and reopen the bash window.

**Supported Windows Versions:**
- Windows 10 Version 1709 Build 16299 - Fall Creators Update

The WSL filesystem can be accessed over the Windows filesystem under the following path: 
%LOCALAPPDATA%\Packages\CanonicalGroupLimited.UbuntuonWindows_79rhkp1fndgsc\LocalState\rootfs

<b>wsl-install.bat:</b> checks windows requirements and installs the WSL<br />
<b>wsl-install-lampp.bat:</b> installs required lampp packages<br />
<b>wsl-uninstall.bat:</b> uninstalls the package<br />
<b>wsl-autostart.sh:</b> starts installed daemons (apache2, mysql, ssh) on bash open<br />

License: GNU GPLv3

#############################################################################################

**Changelog**

*2017-11-06*

- removed lxrun.exe usage (old beta tool which mybe not support any longer in the future)
- use newest package from Windows Store ms-windows-store://pdp/?productid=9NBLGGH4MSV6
- implemented native package installation (same as you use the Windows Store from the UI)
- removed support for any Version before "1709 Build 16299 - Fall Creators Update" for performance and usability reasons
- added curl binary for downloading the package 
