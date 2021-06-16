#!/bin/bash

#测试设备规格：用户名 密码 IP
#my_device=("kylin 123qwe 192.168.17.111","kylin k123123 192.168.17.196")

# my_device=("kylin k123123 192.168.17.89") 以开启
 my_device=("kylin 123qwe 192.168.17.217") #以开启



#此主机的密码
local_password="123.123"

IFS=","
array=($my_device)
#传送到设备端的文件
device_pak_name="device_itp"


#增加权限
chmod +x ssh_login.sh

#循环为每一个设备开启终端
for i in ${array[@]}
do
	mate-terminal -t "$i" -x bash -c "./ssh_login.sh $i $local_password $device_pak_name;exec bash;"
done

exit 0
