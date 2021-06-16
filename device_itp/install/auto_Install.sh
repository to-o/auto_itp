#!/bin/sh
#以最高权限执行

INSTALL=1 		#单执行还是进行安装
CPFILE=1		#复制文件到指定目录
RUNCODE=1		#运行测试

#判断cmake是否安装 未安装进行安装
if ! [ -x "$(command -v cmake)" ]; then
	echo "-------------安装gdb-----------"
	sudo apt update -y
	sudo apt install cmake -y
fi

#安装
if [ $INSTALL ];then
	echo "-------------解压中-----------"
	tar -xvf ltp-full-20200515.tar.bz2
	cd ltp-full-20200515

	echo "-------------编译安装中-----------"
	sudo ./configure
	sudo make -j8 >/dev/null
	echo "-------------编译完成-----------"
	sudo make install >/dev/null
	echo "-------------安装完成-----------"
	cd ..
	sudo rm -rf ltp-full-20200515
	#回到安装目录 在install 下
fi


#复制相应文件到指定位置
if [ $CPFILE ];then
	echo "-------------复制相应的脚本-----------"
	sudo cp ltpstress20200515.sh /opt/ltp/testscripts
	sudo cp stress.part1 /opt/ltp/runtest
	sudo cp stress.part2 /opt/ltp/runtest
	sudo cp stress.part3 /opt/ltp/runtest
	
fi

#执行脚本
if [ $RUNCODE ];then
	#//-t后的参数为运行时间，单位为消失，按照实际设置，一般桌面版本执行24h，服务器版本执行168h，定制版本根据需求设置；-n表示不跑网络压力测试；-p表示生成易读的日志文件；-I表示记录测试日志的文件。
	echo "-------------开始进行脚本测试-----------"
	cd /opt/ltp/testscripts
	sudo chmod 777 ltpstress20200515.sh
	#执行放入后台中
	sudo ./ltpstress20200515.sh -n -t 168 -p -l /opt/ltp/ltpstress.result &
fi

echo "-------------ALL DONE-----------"