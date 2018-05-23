#!/bin/bash
#######################################################
# $Name:         mysql_auto_backup.sh
# $Version:      v1.0
# $Function:     Backup MySQL Databases Script
# $Author:       ShaoBo Wan (Tinywan)
# $organization: https://github.com/Tinywan
# $Create Date:  2017-06-27
# $Description:  定期备份MySQL数据库
# $crontab:  55 23 * * *  bash $PATH/mysql_auto_backup.sh backup >/dev/null 2>&1
#######################################################
 
# Shell Env
SHELL_NAME="mysql_auto_backup.sh"
SHELL_TIME=$(date '+%Y-%m-%d-%H:%M:%S')
SHELL_DAY=$(date '+%Y-%m-%d')
SHELL_DIR="/home/www/data-backup"
SHELL_LOG="${SHELL_DIR}/logs/${SHELL_NAME}-${SHELL_DAY}.log"
LOCK_FILE="/tmp/${SHELL_NAME}.lock"
MYSQL_DUMP="/usr/bin/mysqldump"
MYSQL_BACKUP_DB_NAME="resty"
BACKUP_NAME=${MYSQL_BACKUP_DB_NAME}"-${SHELL_TIME}.sql"
 
# Write Log
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
    echo $"Usage: $0 {backup}"
}
 
shell_lock(){
    touch ${LOCK_FILE}
}
 
shell_unlock(){
    rm -f ${LOCK_FILE}
}
 
mysql_zip(){
    cd $SHELL_DIR
    /bin/bzip2 $BACKUP_NAME
    find ./ -mindepth 1 -maxdepth 3 -type f -name '*.bz2' -mmin +43200 | xargs rm -rf
    find ./ -mindepth 1 -maxdepth 3 -type f -name *.sql -mmin +10080 | xargs rm -rf
    find ./ -mindepth 1 -maxdepth 3 -type f -name *.log -mmin +10080 | xargs rm -rf
}
 
# Backup MySQL weblive Database with mysqldump or innobackupex
mysql_backup(){
    if [ -f "$LOCK_FILE" ];then
        shell_log warn "${SHELL_NAME} is running"
        exit 1
    fi
    shell_log info "mysql backup start"
    shell_lock
    #sleep 10
    #$qMYSQL_DUMP $MYSQL_BACKUP_DB_NAME > $SHELL_DIR/$BACKUP_NAME
    BACKUP_RES=$($MYSQL_DUMP $MYSQL_BACKUP_DB_NAME > $SHELL_DIR/$BACKUP_NAME && echo "success" || echo "fail")
    if [ "${BACKUP_RES}" == "fail" ];then
        shell_log error "MYSQL_BACKUP_DB error : ${BACKUP_RES}"
        shell_unlock
        exit 1
    fi
    mysql_zip
    shell_log info "mysql backup stop"
    shell_unlock
}
 
# Main Function
main(){
    case $1 in
        backup) mysql_backup
        ;;
        *) shell_usage
        ;;
    esac
}
 
#Exec
main $1
