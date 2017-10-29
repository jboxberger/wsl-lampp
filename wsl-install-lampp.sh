# ----------------------------------------------------------------------------------------- #
# Copyright (c) 2017 Juri Boxberger                                                         #
# ----------------------------------------------------------------------------------------- #
# @author Juri Boxberger                                                                    #
# @date 20.10.2017                                                                          #
# License: GNU GPLv3                                                                        #
# ----------------------------------------------------------------------------------------- #
# @version 1.0                                                                              #
# ----------------------------------------------------------------------------------------- #

#!/bin/bash

install_apache(){
    echo ""
    echo "--------------------------------------------------------------------------"
    echo " Apache Setup                                                             "
    echo "--------------------------------------------------------------------------"
    sudo apt-get install -y apache2

    echo ""
    echo "--------------------------------------------------------------------------"
    echo " Set FQDN                                                                 "
    echo "--------------------------------------------------------------------------"
    echo "ServerName localhost" | sudo tee /etc/apache2/conf-available/fqdn.conf

    echo ""
    echo "--------------------------------------------------------------------------"
    echo " Enable Modules Set FQDN                                                  "
    echo "--------------------------------------------------------------------------"
    sudo a2enconf fqdn
    sudo a2enmod rewrite

    echo ""
    echo "--------------------------------------------------------------------------"
    echo " SET WSL Specific Configs                                                 "
    echo "--------------------------------------------------------------------------"

    echo "AcceptFilter http none" | sudo tee -a /etc/apache2/apache2.conf > /dev/null
    echo "AcceptFilter https none" | sudo tee -a /etc/apache2/apache2.conf > /dev/null

    echo ""
    echo "--------------------------------------------------------------------------"
    echo " Apache DocumentRoot Windows Mount Point (e.g. C:\www\html)               "
    echo "--------------------------------------------------------------------------"
    created_dir="false"
    while true; do

        echo 'Please enter Windows Path for the Apache DocumentRoot Mount Point (e.g. C:\www\html)'
        read -r input

        if [ -z "$input" ]; then
            continue
        fi

        original_path=$input
        drive_char=${input:0:1}
        drive_char_lower=$(echo "$drive_char" | tr '[:upper:]' '[:lower:]')
        input=$(echo "$input" | tr "$drive_char" "$drive_char_lower")
        input=$(echo "$input" | tr '\\' '/')
        input=$(echo "$input" | sed 's/://g')
        input="/mnt/$input"

        if ! [ -d "$input" ]; then
            read -p "Path '$original_path' not exists, create? (default: y/n): " do_create_dir
            do_create_dir=${do_create_dir:-y}
            if [ $do_create_dir = "y" ]; then
                if ! mkdir -p $input 2>/dev/null; then
                    echo "Failed to create directory '$original_path'"
                    echo ""
                else
                    created_dir="true"
                    break
                fi
            fi
        else
            break
        fi
    done

    if [ -d "$input" ]; then
        sudo mv /var/www/html /var/www/html.original
        sudo ln -s $input /var/www/html
        if [ $created_dir = "true" ]; then
            sudo cp /var/www/html.original/index.html /var/www/html/
        fi
    fi

    echo ""
    echo "--------------------------------------------------------------------------"
    echo " Start Apache 2 WebServer                                                 "
    echo "--------------------------------------------------------------------------"
    sudo service apache2 start
}

install_mysql(){
    echo ""
    echo "--------------------------------------------------------------------------"
    echo " MySQL Setup                                                              "
    echo "--------------------------------------------------------------------------"
    # Setting MySQL root user password root/root
    # sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $mysql_password"
    # sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $mysql_password"
    sudo apt-get install -y mysql-server
    sudo usermod -d /var/lib/mysql/ mysql

#    read -p "Store Mysql Databases on Windows Filesystem? (default: n/y): " do_use_windows_fs
#    do_use_windows_fs=${do_use_windows_fs:-n}
#    if [ $do_use_windows_fs = "y" ]; then
#        echo ""
#        echo "--------------------------------------------------------------------------"
#        echo " MySQL Database Windows Mount Point (e.g. C:\mysql\databases)             "
#        echo "--------------------------------------------------------------------------"
#        created_dir="false"
#        while true; do
#
#            echo 'Please enter Windows Path for the MySQL Database Windows Mount Point (e.g. C:\mysql\databases)'
#            read -r input
#
#            if [ -z "$input" ]; then
#                continue
#            fi
#
#            original_path=$input
#            drive_char=${input:0:1}
#            drive_char_lower=$(echo "$drive_char" | tr '[:upper:]' '[:lower:]')
#            input=$(echo "$input" | tr "$drive_char" "$drive_char_lower")
#            input=$(echo "$input" | tr '\\' '/')
#            input=$(echo "$input" | sed 's/://g')
#            input="/mnt/$input"
#
#            if ! [ -d "$input" ]; then
#                read -p "Path '$original_path' not exists, create? (default: y/n): " do_create_dir
#                do_create_dir=${do_create_dir:-y}
#                if [ $do_create_dir = "y" ]; then
#                    if ! mkdir -p $input 2>/dev/null; then
#                        echo "Failed to create directory '$original_path'"
#                        echo ""
#                    else
#                        created_dir="true"
#                        break
#                    fi
#                fi
#            else
#                break
#            fi
#        done
#
#        if [ -d "$input" ]; then
#            sudo mv /var/lib/mysql /var/lib/mysql.original
#            sudo ln -s $input /var/lib/mysql
#            if [ $created_dir = "true" ]; then
#                sudo cp -R /var/lib/mysql.original /var/lib/mysql
#                sudo mv /var/lib/mysql/mysql.original/* /var/lib/mysql
#                rm -rf /var/lib/mysql/mysql.original
#            fi
#        fi
#    fi

    echo ""
    echo "--------------------------------------------------------------------------"
    echo " Start Mysql Server                                                       "
    echo "--------------------------------------------------------------------------"
    sudo service mysql start
}

install_php7(){
    echo ""
    echo "--------------------------------------------------------------------------"
    echo " PHP7 Setup                                                              "
    echo "--------------------------------------------------------------------------"
    sudo apt-get install -y php7.0 libapache2-mod-php7.0 php7.0-mcrypt php7.0-mysql php7.0-soap php7.0-curl php7.0-gd php-imagick php7.0-imap php7.0-xmlrpc php7.0-xsl php7.0-mbstring

    echo ""
    echo "--------------------------------------------------------------------------"
    echo " Installing PHP7 XDEBUG                                                   "
    echo "--------------------------------------------------------------------------"
    sudo apt-get install -y php-xdebug
    echo "xdebug.remote_enable=1" | sudo tee -a /etc/php/7.0/mods-available/xdebug.ini > /dev/null
    echo "xdebug.remote_autostart=1" | sudo tee -a /etc/php/7.0/mods-available/xdebug.ini > /dev/null

    # --------------------------------------------------------------------------
    # Check installed Modules and restart
    # --------------------------------------------------------------------------
    if [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
        sudo service apache2 restart
    fi
}

echo ""
echo "--------------------------------------------------------------------------"
echo " Updating APT Package List                                                "
echo "--------------------------------------------------------------------------"
sudo apt-get update

# ---------------------------------------
#          Main Application
# ---------------------------------------

read -p "Upgrade System Packages (default: y/n): " do_apt_upgrade
do_apt_upgrade=${do_apt_upgrade:-y}
if [ $do_apt_upgrade = "y" ]; then
    sudo apt-get upgrade
fi

if [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    read -p "Install Apache2 (default: y/n): " do_install_apache
    do_install_apache=${do_install_apache:-y}
    if [ $do_install_apache = "y" ]; then
        install_apache
    fi
fi

if [ $(dpkg-query -W -f='${Status}' mysql-server 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    read -p "Install MySQL? (default: y/n): " do_install_mysql
    do_install_mysql=${do_install_mysql:-y}
    if [ $do_install_mysql = "y" ]; then
        install_mysql
    fi
fi

if [ $(dpkg-query -W -f='${Status}' php7.0 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    read -p "Install PHP? (default: y/n): " do_install_php
    do_install_php=${do_install_php:-y}
    if [ $do_install_php = "y" ]; then
        install_php7
    fi
fi

# --------------------------------------------------------------------------
# Check installed Mysql/PHP and install PHPMyAdmin
# --------------------------------------------------------------------------
if [ $(dpkg-query -W -f='${Status}' mysql-server 2>/dev/null | grep -c "ok installed") -eq 1 ] && [ $(dpkg-query -W -f='${Status}' php7.0 2>/dev/null | grep -c "ok installed") -eq 1 ] && [ $(dpkg-query -W -f='${Status}' phpmyadmin 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    read -p "Install PhpMyAdmin? (default: y/n): " do_install_pma
    do_install_pma=${do_install_pma:-y}
    if [ $do_install_pma = "y" ]; then
        sudo apt-get -y install phpmyadmin
    fi
fi

clear
echo ""
echo "--------------------------------------------------------------------------"
echo " Enable SSH Service                                                       "
echo " Only needed if you want to connect via putty or WinSCP to your WSL       "
echo " this is not required you can always access the bash over bash.exe and    "
echo " the File System over C:\Users\<user>\AppData\Local\lxss\rootfs           "
echo " This is just in case you need it for any other reasons.                  "
echo "--------------------------------------------------------------------------"
read -p "Enable SSH Service? (default: n/y): " do_enable_ssh
do_enable_ssh=${do_enable_ssh:-n}
if [ $do_enable_ssh = "y" ]; then
    sudo apt-get -y remove --purge openssh-server
    sudo apt-get -y install openssh-server
fi


if ! [ -f ~/wsl-autostart.sh ]; then
    cp "$(dirname $0)/wsl-autostart.sh" ~/wsl-autostart.sh
    echo "if [ -f ~/wsl-autostart.sh ]; then" | sudo tee -a ~/.bashrc > /dev/null
    echo "  ~/wsl-autostart.sh" | sudo tee -a ~/.bashrc > /dev/null
    echo "fi" | sudo tee -a ~/.bashrc > /dev/null
fi