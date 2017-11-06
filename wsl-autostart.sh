# -------------------------------------------------------------------------------------------------------------------- #
# Copyright (c) 2017 Juri Boxberger                                                                                    #
# -------------------------------------------------------------------------------------------------------------------- #
# @author Juri Boxberger                                                                                               #
# @date 20.10.2017                                                                                                     #
# License: GNU GPLv3                                                                                                   #
# -------------------------------------------------------------------------------------------------------------------- #
# @version 1.0                                                                                                         #
# -------------------------------------------------------------------------------------------------------------------- #


#!/bin/sh

if [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
    sudo -S service apache2 start > /dev/null && echo 'Apache Started'
fi

if [ $(dpkg-query -W -f='${Status}' mysql-server 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
    sudo -S service mysql start > /dev/null && echo 'Mysql Started'
fi

if [ $(dpkg-query -W -f='${Status}' openssh-server 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
    sudo -S service ssh --full-restart > /dev/null
fi