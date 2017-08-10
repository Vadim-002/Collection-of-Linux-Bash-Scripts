#!/bin/bash
#-----------------------------
#Filename: adminusers2.sh
#Version: 1.0
#Date: 2017-08-10 10:35:44
#Author: xiaoshuaigege
#Website:www.pojun.tech
#Description: This is a bash script
#-----------------------------
#License: GPL

# 使用示例  adminusers2.sh --add USER_LIST --del USER_LIST -v|--verbose -h|--help
DEBUG=0
ADD=0
DEL=0

for I in `seq  $#`; do
case $1 in
-v|--verbose)
    DEBUG=1
    shift
    ;;
-h|--help)
    echo "Usage:`basename $0` --add USER_LIST --del USER_LIST -v|--verbose -h|--help"
    exit 0
    ;;
--add)
    ADD=1
    ADDUSERS=$2
    shift 2
    ;;
--del)
    DEL=1
    DELUSERS=$2
    shift 2
    ;;
esac
done


if [ $ADD -eq 1 ]; then
    for USER in `echo $ADDUSERS | sed 's@,@ @g'`; do
        if id $USER &> /dev/null; then
            [ $DEBUG -eq 1 ] && echo "$USER exists"
        else
            useradd $USER
            [ $DEBUG -eq 1 ] && echo "Add user $USER finished."
        fi
     done      
fi

if [ $DEL -eq 1 ]; then
    for USER in `echo $DELUSERS | sed 's@,@ @g'`; do
        if id $USER &> /dev/null; then
            userdel -r $USER
            [ $DEBUG -eq 1 ] && echo "Delete user $USER finished "
        else
            [ $DEBUG -eq 1 ] && echo "user $USER not exists."
        fi
    done      
fi
