#!/bin/bash

#-----------------------------
#Filename: Hello
#Version: 1.0
#Date: 2017-08-03 22:05:27
#Author: xiaoshuaigege
#Website:www.pojun.tech
#Description: This is a OS init  bash script
#-----------------------------
#License: GPL
SUCCESS=0
ERROR=100



echo -e "\033[36m
+--------------------------------------------------------------+
|         === Welcome to Centos System init ===                |
+--------------------------------------------------------------+
\033[0m"
# 判断系统版本
OS_RELEASE=`grep -o " [0-9]" /etc/redhat-release|cut -d" " -f2`
if [ "$OS_RELEASE" -eq 7 ];then
	echo   "System Release:CentOS 7 \n   "
#用来执行CentOS7 中特有的 功能
#	bash centos7_init.sh
else [ "$OS_RELEASE" -eq 6 ];
	echo   "System Release:CentOS 6 \n  "
#用来执行CentOS6中与CentOS7不一样的地方
#	bash centos6_init.sh
fi

#添加默认用户
#首先判断是否有相应的用户
id mage &>/dev/null
#$?的作用是引用本条命令的执行结果
if [ $?  -eq 0  ]; then
	echo "the uesr mage has already exits "
else
	useradd mage
	if [ $?  -eq 0 ]; then
		echo 123456|passwd --stdin mage &> /dev/null
	else 
		echo " add user mage error  "
	fi
fi


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

#创建默认的脚本初始化文件 initBashScript.sh
initFile=/bin/initBashScript.sh
#0表示文件不存在 1表示文件已经存在
ifInitFileExits=1;
if [ ! -f "$initFile" ]; then  
    #文件不存在
    ifInitFileExits=0
　　touch "$initFile"  
    chmod +x $initFile
fi  

if [  $ifInitFileExits -eq 0  ]; then 

	cat >>$initFile<<END
	'#!/bin/bash
	[ $# -gt 1 ] && echo "Arg only one" && exit 100
	[ $# -eq 0 ] && read -p "Please input scriptname: " filename
	#判断文件个数
	[ $# -eq 1 ] && filename=$1

	#判断文件是否存在
	[ -a "$filename" ] && echo $filename is exist && exit 101
	#创建文件
	touch $filename
	#加上可执行权限
	chmod +x $filename

	cat > $filename << EOF
	#!/bin/bash
	#-----------------------------
	#Filename: $filename
	#Version: 1.0
	#Date: `date"+%F %T"`
	#Author: mage
	#Website:www.pojun.tech
	#Description: This is a bash script
	#-----------------------------
	#License: GPL

	EOF

	vim +  $filename'
	
END

else 
	echo "touch file initBashScript.sh failed"
	
fi



#配置yum源和epel源
yumRepo=/etc/yum.repos.d/CentOS-Mage.repo
#0表示文件不存在 1表示文件已经存在
ifYumRepoExits=1;
if [ ! -f "$yumRepo" ]; then  
    #文件不存在
    ifYumRepoExits=0
　　touch "$yumRepo"  
fi  

if [  $ifYumRepoExits -eq 0  ]; then 
	cat >> /etc/vimrc <<EOF
		
		[yum]
		name=mage centos yum 
		baseurl=http://172.16.0.1/centos/$releasever/
		gpgcheck=0



		[epel]
		name=mage epel yum
		baseurl=http://172.16.0.1/fedora-epel/$releasever/
		gpgcheck=0

EOF

fi


# 判断是否安装了某个软件包

rpm -q tree

if [ ! $? -eq 0  ]; then 
	# 安装 tree 包
	yum install tree 
	
	[  $? -eq 0  ] && echo "tree has installed"
fi

# 安装ftp 包
rpm -q vsftpd

if [ ! $? -eq 0  ]; then 
	# 安装 ftp
	yum install vsftpd 
	#启动ftp服务
	systemctl start vsftpd 
	#设为开机自动启动ftp服务
	systemctl enable vsftpd 
	
	

fi

# 安装telnet 包
rpm -q telnet

if [ ! $? -eq 0  ]; then 
	# 安装 telnet
	yum install telnet
	[  $? -eq 0  ] && echo "telnet has installed"
fi

# 安装lftp 包
rpm -q lftp

if [ ! $? -eq 0  ]; then 
	# 安装 lftp
	yum install lftp
	[  $? -eq 0  ] && echo "lftp has installed"
fi

exit $SUCCESS
