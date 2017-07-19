#!/bin/bash
#######################################################
# $Name:         shell_template.sh
# $Version:      v1.0
# $Function:     Backup MySQL Databases Script
# $Author:       ShaoBo Wan
# $organization: https://github.com/Tinywan
# $Create Date:  2017-06-27
# $Description:  定期备份MySQL数据库
#######################################################

# Shell Env
SHELL_NAME="test.sh"
SHELL_TIME=$(date "+%Y-%m-%d")
SHELL_DIR="/home/www/database_back"
SHELL_LOG="${SHELL_DIR}/${SHELL_NAME}-${SHELL_TIME}.log"
LOCK_FILE="/tmp/${SHELL_NAME}.lock"
MYSQL_DUMP="/usr/bin/mysqldump"
MYSQL_BACKUP_DB_NAME="weblive"
BACKUP_NAME=${MYSQL_BACKUP_DB_NAME}"-${SHELL_TIME}.sql"

#设置日志级别
loglevel=0 #debug:0; info:1; warn:2; error:3
TIME=`date '+%Y-%m-%d %H:%M:%S'`
shell_log(){
        local log_type=$1
        local LOG_CONTENT=$2
        # 这里的写入日志时间修改掉，经过一段时间的测试${TIME} 每次都是一个固定的时间，所以在这里修改为每次写入是自动获取当前时间写入日志
        logformat="`date '+%Y-%m-%d %H:%M:%S'` \t[${log_type}]\t [${SHELL_NAME}] Function: ${FUNCNAME[@]}\t[line:`caller 0 | awk '{print$1}'`]\t [log_info: ${LOG_CONTENT}]"
        {
        case $log_type in
                debug)
                        [[ $loglevel -le 0 ]] && echo -e "\033[34m${logformat}\033[0m" ;;
                info)
                        [[ $loglevel -le 1 ]] && echo -e "\033[32m${logformat}\033[0m" ;;
                warn)
                        [[ $loglevel -le 2 ]] && echo -e "\033[33m${logformat}\033[0m" ;;
                error)
                        [[ $loglevel -le 3 ]] && echo -e "\033[31m${logformat}\033[0m" ;;
        esac
        } | tee -a $SHELL_LOG
}

# Shell Usage shell_usage函数，用来告诉用户，这个脚本的使用方法
shell_usage(){
    #echo $"Usage: $0 {backup}"
    echo '你没有输入 1 到 4 之间的数字'
}

#   函数shell_lock和shell_unlock非常简单，就是创建一个锁文件
shell_lock(){
    touch ${LOCK_FILE}
}

shell_unlock(){
    rm -f ${LOCK_FILE}
}

# Backup MySQL weblive Database with mysqldump or innobackupex
mysql_backup(){
    if [ -f "$LOCK_FILE" ];then
        shell_log "${SHELL_NAME} is running"
        echo "${SHELL_NAME}" is running && exit
    fi
    shell_log "mysql backup start"
    shell_lock
    sleep 10
    $MYSQL_DUMP $MYSQL_BACKUP_DB_NAME > $SHELL_DIR/$BACKUP_NAME
    cd $SHELL_DIR
    /bin/bzip2 $BACKUP_NAME
    shell_log "mysql backup stop"
    shell_unlock
}

# Main Function
main(){
    case $1 in
        1)  echo '你选择了 1'
        ;;
        2)  echo '你选择了 2'
        ;;
        3)  echo '你选择了 3'
        ;;
        4)  echo '你选择了 4'
        ;;
        *)  shell_usage
        ;;
    esac
}

main2(){
    case $1 in
        backup) mysql_backup
        ;;
        *) shell_usage
        ;;
    esac
}


#Exec
main $1

database=weblive
databak_dir=/home/www/database_back
logs_dir=/home/www/database_back/logs
dumpbin=/usr/bin/mysqldump

DATE=$(date +%Y%m%d)
date_time=$(date +"%y-%m-%d %H:%M:%S")
backup_name=sansan_bak1_${DATE}.sql
logFile=$logs_dir/sansan_${DATE}.log

echo "  " > $logFile
echo "-------------$(date +"%y-%m-%d %H:%M:%S") backup start ----------------------" >> $logFile

$MYSQL_DUMP $MYSQL_BACKUP_NAME >$databak_dir/$backup_name
cd $databak_dir
/bin/bzip2 $backup_name
# 1 mouth = 44640 min
find ./ -mindepth 1 -maxdepth 3 -type f -name *.bz2 -mmin +43200 | xargs rm -rf
find ./ -mindepth 1 -maxdepth 3 -type f -name *.sql -mmin +1440 | xargs rm -rf
echo "-------------$(date +"%y-%m-%d %H:%M:%S") backup end ----------------------" >> $logFile

FFMPEG_JPG=$(/usr/bin/ffmpeg -y -ss 00:00:10 -i ${FULL_NAME} -vframes 1 ${DIR_NAME}/${BASE_NAME}.jpg && echo "success" || echo "fail")