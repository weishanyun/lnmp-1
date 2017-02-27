#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#===============================================================================#
#   System Required:  CentOS/RadHat 5+                                          #
#   Description:  Uninstall LAMP(Linux + Nginx + MySQL + PHP )                  #
#   Author: Teddysun <cn.wangbj@icloud.com>                                     #
#   Intro:  https://blog.wanggufeng.cn                                          #
#===============================================================================#
#to Lowcase
upcase_to_lowcase(){
    words=$1
    echo $words | tr '[A-Z]' '[a-z]'
}

#chk System
check_sys(){
    local checkType=$1
    local value=$2
    local release=''
    local systemPackage=''
    if [[ -f /etc/redhat-release ]];then
        release="centos"
        systemPackage="yum"
    elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat";then
        release="centos"
        systemPackage="yum"
    elif cat /proc/version | grep -q -E -i "centos|red hat|redhat";then
        release="centos"
        systemPackage="yum"
    fi
    if [[ ${checkType} == "sysRelease" ]]; then
        if [ "$value" == "$release" ];then
            return 0
        else
            return 1
        fi
    elif [[ ${checkType} == "packageManager" ]]; then
        if [ "$value" == "$systemPackage" ];then
            return 0
        else
            return 1
        fi
    fi
}

#delete Config
boot_stop(){
    if check_sys packageManager apt;then
        update-rc.d -f $1 remove
    elif check_sys packageManager yum;then
        chkconfig --del $1
    fi
}

#unstall Soft
uninstall(){
    echo "uninstalling Mysqld"
    [ -f /etc/init.d/mysqld ] && /etc/init.d/mysqld stop && boot_stop mysqld
    rm -f /etc/init.d/mysqld
    rm -rf /usr/local/mysql /usr/bin/mysqldump /usr/bin/mysql /etc/my.cnf /etc/ld.so.conf.d/mysql.conf
    echo "Sucess"
    echo "uninstalling Nginx"
    [ -f /etc/init.d/nginx ] && /etc/init.d/nginx stop && boot_stop nginx
    rm -f /etc/init.d/nginx
    rm -rf /usr/local/nginx /usr/sbin/nginx /var/log/nginx /etc/logrotate.d/nginx cat
    echo "Sucess"
    echo "uninstalling PHP"
    rm -rf /usr/local/php5
    rm -rf /usr/local/php7
    rm -rf /usr/bin/php /usr/bin/php-config /usr/bin/phpize /etc/php.ini
    echo "Sucess"
    echo "uninstalling Others software"
    [ -f /etc/init.d/memcached ] && /etc/init.d/memcached stop && boot_stop memcached
    rm -f /etc/init.d/memcached
    rm -fr /usr/local/memcached /usr/bin/memcached
    [ -f /etc/init.d/redis-server ] && /etc/init.d/redis-server stop && boot_stop redis-server
    rm -f /etc/init.d/redis-server
    rm -rf /usr/local/redis
    rm -rf /usr/local/libiconv /usr/lib64/libiconv.so.0 /usr/lib/libiconv.so.0
    rm -rf /usr/local/pcre
    rm -rf /usr/local/openssl
    echo "Sucess"
    echo
    echo "Successfully uninstall LAMP!"
}

while :
do
    read -p "Are you sure uninstall LNMP? (Default: n) (y/n)" uninstall
    [ -z ${uninstall} ] && uninstall="n"
    uninstall="`upcase_to_lowcase ${uninstall}`"
    case ${uninstall} in
        y) uninstall ; break;;
        n) echo "Uninstall cancelled, nothing to do" ; break;;
        *) echo "Input error!";;
    esac
done