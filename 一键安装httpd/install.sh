#!/bin/bash
#-----------------------------
#Filename: install.sh
#Version: 1.0
#Date: 2017-08-07 20:04:24
#Author: xiaoshuaigege
#Website:www.pojun.tech
#Description: This is a bash script
#-----------------------------
#License: GPL
FIREWALLD_ERROR=101
SELINUX_ERROR=102
INSTALL_ERROR=103
SUCCESS=100

#关闭防火墙
#结果为1表示失败
FIREWALLD_RESULT=1
shutDownFireWallOS7()
{
    echo "It's going to shutdown the firewalld.service"
    systemctl disable firewalld.service && systemctl stop firewalld.service
    FIREWALLD_RESULT=$?
}

shutDownFileWallOS6(){
    echo "It's going to shutdown the firewalld.service"
    chkconfig iptables off &&  service iptables stop
    FIREWALLD_RESULT=$?

}

HTTPD_FILE_VERSION=httpd-2.2.34
INSTALL_DIR=httpd22

OS_RELEASE=`grep -o " [0-9]" /etc/redhat-release|cut -d" " -f2`
if [ "$OS_RELEASE" -eq 7 ];then
    echo   "System Release:CentOS 7 \n   "
    HTTPD_FILE_VERSION=httpd-2.4.27
    INSTALL_DIR=httpd24
    #用来执行CentOS7 中特有的 功能
    shutDownFireWallOS7
else [ "$OS_RELEASE" -eq 6 ];
    HTTPD_FILE_VERSION=httpd-2.2.34
    INSTALL_DIR=httpd22
    echo   "System Release:CentOS 6 \n  "
    #用来执行CentOS6中与CentOS7不一样的地方
    shutDownFileWallOS6
fi

if [ $FIREWALLD_RESULT -eq 0 ]; then
    echo "Firewalld.service is shutted down"
else 
    echo "Shutting down firewalld.service occurs error"
    exit $FIREWALLD_ERROR
fi

#关闭SELinux
disableSELinux(){
    echo "It's going to disable the SELinux"
    setenforce 0
    if [ $? -eq 0 ]; then
        echo "The SELinux has been disabled " 
    else
        echo "An erro has occurred while disalbed SELinux"
        exit $SELINUX_ERROR 
    fi
}

disableSELinux

#第一步 先卸载掉系统中已经存在的httpd的包
yum remove httpd

#安装开发包组
yum groupinstall "Development tools"

#解压文件
tar xvf ${HTTPD_FILE_VERSION}.tar.bz2
#进入到解压后的路径
cd $HTTPD_FILE_VERSION
echo "configure the environment"
#对代码进行配置
./configure --prefix=/app/$INSTALL_DIR/ --sysconfdir=/etc/$INSTALL_DIR/ --enable-ssl

#编译和安装
make && make install
[ $? -eq 0 ] || echo "Installed failed" && exit $INSTALL_ERROR

exit $SUCCESS
