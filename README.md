### 压力测试(ITP)自动化脚本说明

`介绍：`此脚本主要用于自动化进行压力测试，包括启动gdb跟踪某个进程或者strace跟踪，排查压力测试出现的奔溃问题

`注意：`gdb和strace无法同时使用 默认开启gdb跟踪进程状态

`使用方法：`

1. 在run.sh(my_device)数组中添加设备端的信息以`,`分割开多个设备
2. 运行run.sh



`细节描述：`

- 目录树

  ```shell
  .
  ├── device_itp							--此文件夹用于发送到设备端(`注意：必须在桌面目录下`)
  │   ├── install							
  │   │   ├── auto_Install.sh				--自动化安装脚本用安装ITP工具到设备中
  │   │   ├── ltp-full-20200515.tar.bz2
  │   │   ├── ltpstress20200515.sh		
  │   │   ├── REDEME.md
  │   │   ├── stress.part1
  │   │   ├── stress.part2
  │   │   └── stress.part3
  │   ├── moniter.sh						--设备端的启动脚本，包括检测是否安装ITP，启动ITP以及开始跟踪
  │   └── rotate_log						--此目录下的文件用于strace跟踪使用
  │       ├── auto_clear.sh				--清理strace日志记录太多，其清理y
  │       ├── log
  │       └── logrotate.conf
  ├── run.sh 								--启动脚本
  └── ssh_login.sh						--用于scp发送测试脚本到设备端和ssh自动连接
  
  4 directories, 12 files
  ```



- run.sh 脚本简介

  输入设备的用户名、密码、IP等等信息，为每个设备开启终端用于监控设备的状态以及执行脚本

  `注意:`此脚本使用mate-terminal终端，如果使用ubuntu请使用ubuntu的终端软件

- ssh_login.sh

  

  















