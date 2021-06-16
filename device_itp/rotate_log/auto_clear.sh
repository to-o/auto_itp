#!/bin/bash
#一直保持后台运行
#for (( i = 0; i < 60; i++ )); 
#获取当前目录的绝对目录
FILE_PATH=$(cd "$(dirname "$0")"; pwd)

while true
do
    /usr/sbin/logrotate $FILE_PATH/logrotate.conf
    sleep $1
done
exit 0
