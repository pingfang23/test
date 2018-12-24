https://www.cnblogs.com/maybe2030/p/5022595.html
https://www.cnblogs.com/clsn/p/8006210.html#auto_id_28


案例1：清除/var/log下的系统日志messages的简单脚本
备注：
a.要使用root用户运行才有权限清除系统日志messages
b.清空日志的三种方法： echo >test.log;	>test.log;	cat /dev/null >tes.log (黑洞)
#!/bin/bash
LOG_DIR=/var/log
ROOT_UID=0 
#$UID为0时候，用户才具有root权限
if [ "$UID" -ne "$ROOT_UID"]
then
	echo "Must be root to run this script"
	exit 1
fi

cd $LOG_DIR || {
	echo "Cannot change to the directory." >$2
	exit 1
}

cat /dev/null > messages && echo "Logs cleande up"
exit 0



----------------------------------------------------------------
企业面试题一例：Centos linux系统默认的shell是（）
解答：bash
查看方法：
1.echo $SHELL
2.grep root /etc/passwd



----------------------------------------------------------------
shell脚本基本规范及习惯
1）开头制定脚本解释器
#!/bin/bash 或者 #!/bin/sh
2）开头加版本版权等信息
#Date: 2013-07-07
#Author: Create by liuping
#Mail: 2474568999@qq.com
#Function: This script is for MySQL backup
#Version: 1.1
以上信息可以自动加，方法是修改~/.vimrc配置文件 
3）脚本中不用中文注释
4）脚本以.sh为扩展名
5）代码习惯：a.成对内容一次写()[]{}...; b.[]两端要有空格; c.流程控制语句格式一次写完; 
6）通过缩进让代码易读.



----------------------------------------------------------------
案例A：批量文件改名案例实践（把下面文件名中finished去掉）
stu_102999_1_finished.jpg
stu_102999_2_finished.jpg
stu_102999_3_finished.jpg
stu_102999_4_finished.jpg
#!/bin/bash
for f in `ls *.jpg`
do
	mv $f `echo ${f%finished*}.jpg`
done

案例B:批量处理文件扩展名（文件扩展名变成大写）
#!/bin/bash
for f in `ls *.jpg`
do
	mv $f `echo ${f/%jpg/JPG}`
done

案例C:rename 将.JPG改成htm后缀
#!/bin/bash
#rename [from] [to] [file]
rename .JPG .htm *.JPG



----------------------------------------------------------------

1.脚本执行先找环境变量,在执行脚本内容.
全局环境变量
cat /etc/profile
全局环境变量
cat /etc/profild.d/
用户环境变量
ll /home/oldboy/ -al (.bashrc/.bash_profile)

2.shell脚本执行采取三种方式
bash scriptname 或  sh scriptname (直接可执行--推荐)
path/scriptname 或 ./scriptname  (当前路径,需要权限)
source scriptname 或 . scriptname (此执行后的变量，父脚本可直接调用)
例题：已知如下命令级返回结果，请问echo $user 返回结果为什么（答案：空）
[oldboy@test]$cat test.sh
user=`whoani`
[oldboy@test]$sh test.sh
[oldboy@test]$echo $user


----------------------------------------------------------------

变量：环境变量（全局变量） 和 局部变量

环境变量：通常大写，应用于进程前，需要用export导出
echo $HOME   	/root
echo $USER		root
echo $UID		0
echo $SHELL		/bin/bash

定义变量
1.export 变量名=value
	export oldboy="I am oldboy"  (source /etc/profile)
2.变量名=value; export 变量名
	a="i is a"
	b="i is b"
	c="i is c"
	export a b c 
3.declare -x 变量名=value


----------------------------------------------------------------

变量案例：
a=192.168.1.1
b=192.168.1.1
c=192.168.1.1
a=192.168.1.1-$a
b='192.168.1.1-$a'
c="192.168.1.1-$a"
echo "a=$a" 	#a=192.168.1.1-192.168.1.1
echo "b=$b"		#b=192.168.1.1-$a  （单引号不解析，是什么就是什么，双引号会解析）
echo "c=${c}"	#c=192.168.1.1-192.168.1.1-192.168.1.1
#习惯：数字不加引号，其他默认加双引号；特殊例子：awk是相反的。



位置参数
/root/t.sh
dirname $0  : /root   路径
basename $0	: t.sh   脚本名
$0 $1 $2...
$#	(个数) 
$*	所有参数
$@	所有参数
$_	最后一个参数

进程状态变量：
$? 
0	表示成功
2	权限拒绝
1~125 表示运行失败
126	找到命令，但无法执行
127	不存在命令
$$ 取当前shell的进程号（PID）



bash内部变量
echo
export
read
exit

eval
exec
shift	位置参数往前推   cmd -i xxx  if [ '-i' = $1 ];then shift
(.)



----------------------------------------------------------------
OLDBOY="I am oldboy"
${#OLDBOY}
${OLDBOY:N}
${OLDBOY:N:M}
${OLDBOY#str}
${OLDBOY##str}
${OLDBOY%str}
${OLDBOY%%str}




----------------------------------------------------------------


解决空字符串问题，判断变量是否没用定义
1.${value:-word}
result=${oldgril:-UNSET}		变量定义就输出变量，没内容就返回后面的UNSET
echo $result 		 (UNSET)

oldgril="beautiful gril"
result=${oldgril:-UNSET}
echo $result  		(beautiful gril)

应用：rm -rf ${path1-/tmp} 

2.${value:=word}
result=${test:=UNSET} 		变量不存在时候，给变量赋值，
echo $result  		(UNSET)
echo $test 			(UNSET)

3.生产应用场景
1)./etc/init.d/httpd
2)./etc/init.d/crond
3).对变量的路径进行操作，最好线判断路径是不是非空.
path=/server/backup
find ${path:=/tmp/} -name "*.tar.gz" -type f |xargs rm -f




----------------------------------------------------------------

chars=`seq -s " " 100`
echo $chars

统计字符长度的方法
echo ${#chars}
echo $chars |wc -m
echo $(expr length "$chars")

time for i in $(seq 11111);do count=${#chars};done;
time for i in $(seq 11111);do count=`echo $chars |wc -m`;done;
time for i in $(seq 11111);do count=e`echo $(expr length "$chars")`;done;
统计耗时对比（尽量用内置操作）
https://www.cnblogs.com/chengmo/archive/2010/10/02/1841355.html


----------------------------------------------------------------


变量的数值运算
(())	let	expr	bc	$[]

1.(()) 执行简单的整数运算 %(( )),很常用，且效率高,如下：

((a=1+2**3-4%3))
b=$((1+2**3-4%3))
echo $((1+2**3-4%3))
echo $((3>2))		#1
echo $((3>8))		#0

2.let
i=2
let i=i+8
echo $i

3.expr （运算符左右都要要有空格；*需要转义）
expr 2 + 2
expr $[2+3]






Liunx系统产生随机数的6中方法：
1.通过系统环境变量
$RANDOM

2.通过openssl产生随机数
openssl rand -base64 8
openssl rand -base64 8 |md5sum

3.通过时间获取随机数
date +%s%N

4./dev/random设备
head /dev/urandom |cksum

5.利用UUID处理
cat /proc/sys/kernel/random/uuid
cat /proc/sys/kernel/random/uuid|md5sum

6.yum install expect -y
mkpasswd
mkpasswd -l 8 |md5sum

检查随机数的唯一性：
echo $RANDOM |md5sum |cut -c 1-9 |sort|uniq -c |sort -nkl
for n in `seq 20`;do echo $RANDOM |md5sum |cut -c 1-9;done|sort|uniq -c |sort -rn -k1
for n in `seq 20`;do date +%s%N |md5sum |cut -c 1-9;done|sort|uniq -c |sort -rn -k1




read
-p 设置用户提示信息
-t 设置超时退出
read -p "pls input:" var
read -t 10 -p "pls input:" var 

read -t 10 -p "pls input:" var1 var2 
等同于：
echo -n "pls input:" (-n 不换行)
read var1 var2

判断var1 var2是不是整数
while true
do
	expr $var1 + 0 >/dev/null 2>$1
	[ $? -ne 0 ] $$ continue
	expr $var2 + 0 >/dev/null
	[ $? -ne 0 ] $$ continue || break
done


======================
测试
格式1	test 测试条件
格式2	[ 测试条件 ]
格式3	[[ 测试条件 ]]

test -f file $$ echo 1||echo 0
[ -f file ] $$ echo 1||echo 0
[[ -f file ]] $$ cat file
[ -f file && -d folder ] $$ echo 1||echo 0
[ -f file -a -d folder ] $$ echo 1||echo 0
-f
-d
-s 存在且不为空 -size
-e
-r -w -x
-L
f1 -nt f2  f1比f2新
f1 -ot f2  f1比f2旧




============================
字符串测试操作符
-z 字符串   长度为0则真
-n 字符串 	长度不为0则真
字符1 = 字符1	比较2个字符串是否相同 ，与==等价	if [ "${a}" = "${b}"] 
!=

整数二元比较
在[]中比较		在(()) 和[[]]中比较		说明

-eq				==						equal
-ne				!=						not equal
-gt				>						greater then
-ge				>=						greater equal
-lt				<						less
-le				<=						less equal	

[[ "$a" < "$b" ]] ,在[]中如果用需要转义 [ "$a" \< "$b" ] 
经过实践  =和!= 不需要转义


逻辑操作法
在[]中比较		在[[]]中比较		说明
-a				&&					与 and
-o				||					或 or
！				！					非

[ -f "$file" ] && echo 1||echo 0
等同于：
if [ -f "$file" ];then
	echo 1
else 
	echo 0
fi

[ -f "$file1" -o -e "$file2" ]&& echo 1||echo 0
[ -f "$file1" || -e "$file2" ]&& echo 1||echo 0  (错的)
[[ -f "$file1" || -e "$file2" ]]&& echo 1||echo 0  
[ -f "$file1" ] && [ -e "$file2" ]&& echo 1||echo 0 








=========================================


生产环境监控MySQL服务实例

A.监控MySQL服务的方法:
方法一. 过滤MySQL端口3306进行判断
port=`netstat -lnt|grep 3306 | awk -F '[ :]+' '{print $5}'`
if [ "$port" == "3306" ]; then
	echo 'db is running'
else
	/date/3306/mysql restart
fi

方法二. 过滤MySQL端口3306进行判断 (该方法实用/简单/常用)
portNum=`netstat -lnt|grep 3306|wc -l`
if [ $portNum -eq 1 ]; then
	echo 'db is running'
else
	/date/3306/mysql restart
fi


B.MySQL端口和进程同时存在，即认为MySQL服务正常.
方法一（简单版本）
portNum=`netstat -lnt|grep 3306|wc -l`  （一个3306端口）
mysqlProcessNum=`ps -ef|grep mysqld|grep -v grep |wc-l`   （两个进程号）
if [ $portNum -eq 1 -a $mysqlProcessNum -eq 2]; then
	echo "db is runnung"
else
	/date/3306/mysql start
fi

方法二（复杂版本）
MYSQL=date/3306/mysql
LogPath=/tmp/mysql.log
portNum=`netstat -lnt|grep 3306|wc -l`  #（一个3306端口）
mysqlProcessNum=`ps -ef|grep mysqld|grep -v grep |wc-l`   #（两个进程号）
if [ $portNum -eq 1 -a $mysqlProcessNum -eq 2]; then
	echo "db is runnung"
else
	$MYSQL start>$LogPath
	sleep 10
	portNum=`netstat -lnt|grep 3306|wc -l`
	mysqlProcessNum=`ps -ef|grep mysqld|grep -v grep |wc-l`
	if [ $portNum -ne 1 -a $mysqlProcessNum -ne 2];then
		while true
		do
			killall mysqld >/dev/null 2>&1
			[ $? -ne 0 ] && break 
			sleep
		done
		$MYSQL start >>$LogPath && status="successful" || status="failure"
		mail -s "mysql status is $status" < 247456899@qq.com < $$LogPath
	fi
fi
































