#!/bin/bash
#-----------------------------
#Filename: adminusers.sh
#Version: 1.0
#Date: 2017-08-10 10:35:44
#Author: xiaoshuaigege
#Website:www.pojun.tech
#Description: This is a bash script
#-----------------------------
#License: GPL
ARGS_ERROR=100
UNKONW_ARG_ERROR=101
SUCCESS=0

if [ $1 == "--help" ]; then 
    echo "Usage:adminusers.sh --add USER1,USER2...| --del USER1,USER2....|--help"
    exit $SUCCESS

fi



if [  $# -ne 2 ]; then
    echo "Usage:adminusers ARG userlists"
    exit $ARGS_ERROR
fi
USERS=`echo $2 |sed 's/,/ /g'`
echo $USERS
if [ $1 == "--add" ]; then 
    for I in $USERS; do
        if id $I &> /dev/null; then
            echo "$I exits"
        else
            adduser $I
            echo $I | passwd --stdin user$I &> /dev/null
            echo "Add $I finished"
         fi
    done
elif [ $1 == "--del" ]; then
    for I in $USERS; do 
        if id $I &> /dev/null; then 
            userdel -r $I
            echo "Delete $I finished"
        else
            echo "No $I"
        fi
     done

else 
    echo "Unkonw ARG"
    exit $UNKONW_ARG_ERROR
fi





