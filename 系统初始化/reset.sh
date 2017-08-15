#!/bin/bash
#-----------------------------
#Filename: reset.sh
#Version: 0.5
#Date: 2017-08-15 15:05:27
#Author: xiaoshuaigege
#Website:www.pojun.tech
#Description: This is a OS init  bash script
#-----------------------------
#License: GPL
SUCCESS=0
ERROR=100
ROOT_ERROR=101
VERBOSE=0


#先判断当前用户，只有root用户能够执行这个脚本

if [[ "$(whoami)" != 'root'  ]]; then 
    echo "Only root can run this script!!"
    exit $ROOT_ERROR
fi

echoUsage(){
    echo -e "
Usage:
     -v|--verbose    see what is being done
     -h|--help       display this play text and exit
     -d|--default    to initialize the system by default
    "
}
# 如果用户默认不加任何选项，将提示默认安装
if [ $# -eq 0  ]; then
    read -p "The system is going to be initialized by default [y/n]?" CHOOSE
    #如果选择n则提示脚本的使用方法
    [ "$CHOOSE" == "N"  ] || [ "$CHOOSE" == "n" ] && {
        echoUsage
		exit $SUCCESS
    }
    #选择y则进行默认安装
else
    #判断help选项和verbose选项
    for I in 'seq $#'; do
    case $1 in
    -v|--verbose)
        VERBOSE=1
        shift 1
        ;;
    -h|--help)
        echo -e "Name: `basename $0` -init the mini Linux"
        echoUsage
        exit $SUCCESS
        ;;
    -d|--default)
        # 目前默认只支持默认安装，以后会加入更多的内容
        # 如果不输入-d 选项的话，会提示是否默认安装
        ;;
    esac
    done
fi

#提示系统即将被初始化
[ $VERBOSE -eq 1 ] && echo "The system is going to be initialized"

#CentOS 7 中的特殊操作
centos7init(){
    #关闭防火墙
    systemctl disable firewalld.service
    systemctl stop firewalld.service
    [ $VERBOSE -eq 1 ] && echo "firewalld is closed"
	
	
	#初始化网络环境
	[ $VERBOSE -eq 1 ] && echo "restart network"
	sed -i 's/ONBOOT-NO/ONBOOT=yes/' ifcfg-enss33
	service network restart
}
#CentOS 6中的特殊操作
centos6init(){
    #关闭防火墙
    chkconfig iptables off
    service iptables stop
    [ $VERBOSE -eq 1] && echo "iptables is closed"
}

#关闭SELinux
closeSELinux(){
    sed -n 's/^SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config
    [ $VERBOSE -eq 1 ] && echo "SELinux is closed"
}

#判断系统版本
OS_RELEASE=`grep -o " [0-9]" /etc/redhat-release|cut -d" " -f2`
if [ "$OS_RELEASE" -eq 7 ]; then
    centos7init
elif [ "$OS_RELEASE" -eq 6 ]; then
    centos6init
fi

#调用
closeSELinux

#添加默认用户
#首先判断是否已经有了默认的用户
id mage &> /dev/null

if [ $?  -eq 0  ]; then
    [ $VERBOSE -eq 1 ] && echo "the uesr mage has already exits"
else
    useradd mage
    if [ $?  -eq 0 ]; then
        echo 123456|passwd --stdin mage &> /dev/null
        [ $VERBOSE -eq 1 ] && echo "add user mage succeed"
    else
        [ $VERBOSE -eq 1 ] && echo "add user mage error"
    fi
fi


#配置yum源和epel源
YUM_REPO=/etc/yum.repos.d/sysinit.repo
#0表示文件不存在 1表示文件已经存在
YUM_REPO_EXITS=1
if [ ! -f  "$YUM_REPO" ]; then 
    #文件不存在
    YUM_REPO_EXITS=0
    touch "$YUM_REPO"
    [  $? -eq 0  ] && [ $VERBOSE -eq 1 ] && echo "touch file $YUM_REPO SUCCESS"
fi

# 向文件中追加yum源的配置内容
if [  $YUM_REPO_EXITS -eq 0  ]; then

	if [ "$OS_RELEASE" -eq 7 ]; then
    cat >> $YUM_REPO << EOF

[yum]
name=mage centos yum
baseurl=http://172.16.0.1/centos/7/
gpgcheck=0

[epel]
name=mage epel yum
baseurl=http://172.16.0.1/fedora-epel/7/x86_64/
gpgcheck=0
		
EOF
	elif [ "$OS_RELEASE" -eq 6 ]; then
		cat >> $YUM_REPO << EOF

[yum]
name=mage centos yum
baseurl=http://172.16.0.1/centos/6/
gpgcheck=0

[epel]
name=mage epel yum
baseurl=http://172.16.0.1/fedora-epel/6/x86_64/
gpgcheck=0
		
EOF
	fi
    

[ $VERBOSE -eq 1 ] && echo "yum repository has been established"

fi


# 判断是否安装了vim
installVim(){
rpm -q vim

if [  $? -ne 0  ]; then 
	# 安装 vim 包
	yum install vim 
	
	[  $? -eq 0  ] &&  [ $VERBOSE -eq 1 ] && echo "vim has installed"
	
#配置vim的一些默认属性
#静默模式判断该配置文件中是否已经定义过相关的属性，如果是，则不添加配置
#如果没有添加过，则进行添加
grep -q "\<mage setting\>" /etc/vimrc ||{
	cat >> /etc/vimrc <<EOF
	"mage setting"
	set nu  #
	set sm
	set ai
	set hlsearch
	set ts=4
	syntax on
EOF
}
fi
}


# 判断是否安装了ssh
installSSH(){
rpm -q ssh

if [ ! $? -eq 0  ]; then 
	# 安装 ssh 包
	yum install ssh 
	
	[  $? -eq 0  ] &&  [ $VERBOSE -eq 1 ] && echo "ssh has installed"
fi
}



# 判断是否安装了Tree
installTree(){
rpm -q tree

if [  $? -ne 0  ]; then 
	# 安装 tree 包
	yum install tree 
	
	[  $? -eq 0  ] &&  [ $VERBOSE -eq 1 ]  && echo "tree has installed"
fi
}
# 安装ftp 包
installFtp(){
rpm -q vsftpd

if [ $? -ne 0  ]; then 
	# 安装 ftp
	yum install vsftpd 
	[  $? -eq 0  ] &&  [ $VERBOSE -eq 1 ]  && echo "vsftpd has installed"
	#启动ftp服务
	systemctl start vsftpd 
	#设为开机自动启动ftp服务
	systemctl enable vsftpd 

fi
}

# 安装telnet 包
installTelnet(){
rpm -q telnet

if [ $? -ne 0  ]; then 
	# 安装 telnet
	yum install telnet
	[  $? -eq 0  ]  &&  [ $VERBOSE -eq 1 ] && echo "telnet has installed"
fi
}


# 安装lftp 包
installLftp(){
rpm -q lftp

if [ $? -ne 0  ]; then 
	# 安装 lftp
	yum install lftp
	[  $? -eq 0  ]  &&  [ $VERBOSE -eq 1 ] && echo "lftp has installed"
fi
}
# 安装autofs
installAutofs(){
rpm -q autofs

if [  $? -ne 0  ]; then 
	# 安装 autofs
	yum install autofs
	[  $? -eq 0  ]  &&  [ $VERBOSE -eq 1 ] && echo "autofs has installed"
fi
}

installVim
installSSH
installTree
installFtp
installTelnet
installLftp


installDevelopmentTools(){

	yum  groupinstall Development tools

}


exit $SUCCESS
