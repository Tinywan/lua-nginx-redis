#!/bin/bash
#function: Nginx log timing backup and delete

# get nginx PID
#   pid = $(cat /var/run/nginx.pid)
pid=$(ps -aef | grep nginx | grep -v grep | grep master |awk '{print $2}')

# if nginx running  else exit 1
if [[ $? == 0 && -n $pid ]]
then
    exit 1;
fi

#set the path save nginx log files
base_path="/home/tinywan/logs"

# get data eg：201611
log_dir_name=$(date -d yesterday +"%Y%m")

# get days eg：03
DAY=$(date -d yesterday +"%d")

# create log directory
mkdir -p $base_path/$log_dir_name

# set the path to nginx log
log_files_path="/usr/local/nginx/logs/"

#set nginx log files you want to cut eg: array
log_files_names=(access error)

#set the path to nginx.
nginx_sbin="/usr/local/nginx/sbin/nginx"

#Set how long you want to save eg: 7 days
save_mins=1

#log file num eg: 2
log_files_num=${#log_files_names[@]}

#loop cut nginx log files
for log_name in ${log_files_names[*]}
do
   sudo mv ${log_files_path}${log_name}.log ${base_path}/${log_dir_name}/${log_name}_${DAY}.log
done

#向 Nginx 主进程发送 USR1 信号,USR1 信号是重新打开日志文件
sudo kill -USR1 $pid

#delete 7 days ago nginx log files
find $base_path -mindepth 1 -maxdepth 3 -type f -name "*.log" -mmin +$save_mins | xargs rm -rf

#################### crontab edit 每天凌晨 1:55 执行该脚本 #####################
# 55 1 * * * bash /home/tinywan/shell/nginx_log_cut.sh >/dev/null 2>&1
##############################################################################

