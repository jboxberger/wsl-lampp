**WSL (Windows Subsystem for Linux) LAMPP Installer**

Automated LAMPP installer for the LAMPP Windows Subsystem for Linux. You can choose the modules you need During the installation.
- Apache 2
- PHP 7.0
- MySql
- PhpMyAdmin
- SSH Daemon

**Supported Windows Versions:**
- Version 1703 Build 15063
- Version 1709 Build 16299

The WSL filesystem can be accessed over the Windows filesystem under the following path: 
C:\Users\<user>\AppData\Local\lxss\rootfs

wsl-install.bat: checks windows requirements and installs the WSL
wsl-install-lampp.bat: installs required lampp packages
wsl-autostart.sh: starts installed daemons (apache2, mysql, ssh) on bash open

License: GNU GPLv3