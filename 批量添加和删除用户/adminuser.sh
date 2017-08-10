#!/bin/bash
#-----------------------------
#Filename: usertest3.sh
#Version: 1.0
#Date: 2017-08-10 10:35:44
#Author: xiaoshuaigege
#Website:www.pojun.tech
#Description: This is a bash script
#-----------------------------
#License: GPL
NO_ARGS_ERROR=100
UNKONW_ARG_ERROR=101


if [ $# -lt 1 ]; then
    echo "Usage:adminusers ARG"
    exit $NO_ARGS_ERROR
fi

if [ $1 == "--add" ]; then 
    for I in {1..10}; do
        if id user$I &> /dev/null; then
            echo "user$I exits"
        else
            adduser user$I
            echo user$I | passwd --stdin user$I &> /dev/null
            echo "add user$I finished"
         fi
    done
elif [ $1 == "--del" ]; then
    for I in {1..10}; do 
        if id user$I &> /dev/null; then 
            userdel -r user$I
            echo "Delete user$I finished"
        else
            echo "No user$I"
        fi
     done

else 
    echo "Unkonw ARG"
    exit $UNKONW_ARG_ERROR
fi





