#!/usr/bin/expect -f

set timeout 10
set username 	       [lindex $argv 0]
set password		   [lindex $argv 1]
set realip             [lindex $argv 2]
set local_password     [lindex $argv 3]
set device_pak         [lindex $argv 4]

#---------------------更新ITP脚本到设备中------------------------------

spawn sudo scp -r ./$device_pak $username@$realip:/home/$username/桌面

#本地SSH连接需要密码连接 
expect "*密码*"
send "$local_password\n"

expect {
		"yes/no" { send "yes\r"; exp_continue }
		"password" { send "$password\r" };
}
#在此检测传输完成
expect "*8331*"
#----------------------------结束--------------------------------------


#ssh 自动连接
spawn sudo ssh $username@$realip

#本地SSH连接需要密码连接 
expect "*密码*"
send "$local_password\n"

expect {
    "(yes/no)?" {
        send "yes\n"
        expect "password:"
        send "$password\n"
    }
    "password:" {
        send "$password\n"
    }
}

#在此SSH以连入设备
expect "*$*"

#在此进行判断是否存在脚本  不存在发送到设备端
send "cd /home/$username/桌面/$device_pak\n"
expect {
    "*目录*" {						#表示目标设备没有所需要的脚本
		#传输ITP工具到设备中
		spawn sudo scp -r ./$device_pak $username@$realip:/home/$username/桌面

		#本地SSH连接需要密码连接 
		expect "*密码*"
		send "$local_password\n"

		expect {
				"yes/no" { send "yes\r"; exp_continue }
				"password" { send "$password\r" };
		}
    }
	#此处表示已经包含所需的脚本
    "*桌面/$device_pak*" {				
		#对当前目录下的所有脚本加执行权限
		send "chmod -R +x .\n"	
		send "sudo ./moniter.sh\n"
		expect "*密码*"
		send "$password\n"
    }
}

interact










