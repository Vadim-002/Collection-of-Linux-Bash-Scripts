#!/bin/bash
#-----------------------------
#Filename: listuser.sh
#Version: 1.0
#Date: 2017-08-09 21:53:00
#Author: xiaoshuaigege
#Website:www.pojun.tech
#Description: This is a bash script
#-----------------------------
#License: GPL
#列举出系统中现有的所有用户
LINES=`cat /etc/passwd | wc -l`
for I in `seq $LINES`; do echo "hello `head -n $I /etc/passwd| tail -1 | cut -d: -f1`"; done;
