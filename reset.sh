#!/bin/bash

#!/bin/bash
#-----------------------------
#Filename: Hello
#Version: 1.0
#Date: 2017-08-03 22:05:27
#Author: xiaoshuaigege
#Website:www.pojun.tech
#Description: This is a OS init  bash script
#-----------------------------
#License: GPL^
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
#	bash centos7_init.sh
else [ "$OS_RELEASE" -eq 6 ];
	echo   "System Release:CentOS 6 \n  "
#	bash centos6_init.sh
fi

#添加默认用户

id mage &>/dev/null

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

cat >> /etc/vimrc <<EOF
"mage setting "
set nu
set sm
set ai
set hlsearch
syntax on
EOF

#创建默认的脚本初始化文件 initBashScript.sh
#init=/bin/initBashScript.sh
#
#touch $init
#if [  $? -eq 0  ]; then 
#	
#	chmod +x $init
#	
#	cat >>$init<<END
#	#!/bin/bash
#	[ $# -gt 1 ] && echo "Arg only one" && exit 100
#	[ $# -eq 0 ] && read -p "Please input scriptname: " filename
#	#判断文件个数
#	[ $# -eq 1 ] && filename=$1
#
#	#判断文件是否存在
#	[ -a "$filename" ] && echo $filename is exist && exit 101
#	#创建文件
#	touch $filename
#	#加上可执行权限
#	chmod +x $filename
#
#	cat > $filename << EOF
#	#!/bin/bash
#	#-----------------------------
#	#Filename: $filename
#	#Version: 1.0
#	#Date: `date"+%F %T"`
#	#Author: mage
#	#Website:www.pojun.tech
#	#Description: This is a bash script
#	#-----------------------------
#	#License: GPL
#
#	EOF
#
#	vim +  $filename
#	
#END
#
#else 
#	echo "touch file initBashScript.sh failed"
#	
#fi
#








exit $SUCCESS
