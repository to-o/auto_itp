#!/bin/sh
###
 # @Author: your name
 # @Date: 2021-06-16 16:46:44
 # @LastEditTime: 2021-06-16 19:12:08
 # @LastEditors: Please set LastEditors
 # @Description: In User Settings Edit
 # @FilePath: \auto_itp\device_itp\moniter.sh
### 

OPEN_LOG=1				#是否使用单独记录日志功能 防止日志被覆盖
OPEN_GDB=1				#开启GDB

#OPEN_STRACE=1 			#是否使用strace追踪进程
LOG_TIME_INTERVAL=10	#检测时间 单位S


scripts_file="/opt/ltp/testscripts/ltpstress20200515.sh"

#来判断是否已经安装脚本
if [ ! -f "$scripts_file" ]; then
	#未安装 执行安装脚本
	echo "-------------安装ITP工具中-----------"
	cd ./install
	sudo ./auto_Install.sh
	echo "-------------安装ITP工具完成-----------"
fi


#判断压力测试脚本是否运行 未运行 先进行运行
PROC_NAME=ltpstress20200515.sh
ProcNumber=`ps -ef |grep -w $PROC_NAME|grep -v grep|wc -l`
if [ $ProcNumber -le 0 ];then
	echo "-------------正在启动ITP脚本-----------"
	cd /opt/ltp/testscripts
	sudo chmod +x ltpstress20200515.sh
	#执行放入后台中
	sudo ./ltpstress20200515.sh -n -t 168 -p -l /opt/ltp/ltpstress.result >/dev/null 2>&1 &
	echo "-------------启动ITP脚本完成-----------"
fi


#最终进去脚本执行目录
cd /home/$SUDO_USER/桌面/device_itp

#获取当前目录的绝对目录
FILE_PATH=$(cd "$(dirname "$0")"; pwd)

#判断gdb是否安装 未安装进行安装
if ! [ -x "$(command -v gdb)" ]; then
	echo "-------------安装gdb-----------"
	sudo apt update -y >/dev/null
	sudo apt install gdb -y >/dev/null
	echo "-------------gdb安装完成-----------"
fi

#是否是能log日志跟踪
if [ $OPEN_LOG ];then
	echo "-------------后台记录ukui的日志变动-----------"
	tail -f /home/$SUDO_USER/.log/ukui_kwin_0.log > $FILE_PATH/rotate_log/log/m_ukui.log &
fi

#是否开启log日志跟踪 全部运行在后台当中
if [ $OPEN_STRACE ];then
	echo "-------------strace 开启追踪-----------"
	sudo strace -T -tt -e trace=all -p $(pidof ukui-kwin_wayland) >> $FILE_PATH/rotate_log/log/strace_output.log 2>&1 &
	
	#为logrotate配置文件切换成root属性 --- 必须
	sudo chgrp root ./rotate_log/logrotate.conf
	sudo chown root ./rotate_log/logrotate.conf
	
	chmod 777 ./rotate_log/auto_clear.sh
	sudo chmod 644 ./rotate_log/logrotate.conf
	#strace记录日志日志较多 按大小进行清理
	sudo ./rotate_log/auto_clear.sh $LOG_TIME_INTERVAL &
fi

if [ $OPEN_GDB ];then
	echo "-------------gdb 开启追踪-----------"
	sudo gdb -pid $(pidof ukui-kwin_wayland) -batch -ex "set logging file kwin_wayland.gdb" -ex "set logging on" -ex "continue" -ex "thread apply all backtrace"
fi

exit 0