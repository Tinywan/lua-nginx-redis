#!/bin/bash
#######################################################
# $Name:         mysql_backup.sh
# $Version:      v1.0
# $Function:     Backup MySQL Databases Script
# $Author:       ShaoBo Wan (Tinywan)
# $organization: https://github.com/Tinywan
# $Create Date:  2017-06-29
# $Description:  Mysql 自动备份脚本安全加锁机制
#######################################################

# Shell Env
SHELL_NAME="mysql_backup.sh"
SHELL_TIME=$(date "+%Y-%m-%d")
SHELL_DIR="/home/www/database_back"
SHELL_LOG="${SHELL_DIR}/${SHELL_NAME}-${SHELL_TIME}.log"
LOCK_FILE="/tmp/${SHELL_NAME}.lock"
MYSQL_DUMP="/usr/bin/mysqldump"
MYSQL_BACKUP_DB_NAME="tinywan_mysql"
BACKUP_NAME=${MYSQL_BACKUP_DB_NAME}"-${SHELL_TIME}.sql"

# Write Log
loglevel=0 #debug:0; info:1; warn:2; error:3
TIME=`date '+%Y-%m-%d %H:%M:%S'`
shell_log(){
        local log_type=$1
        local LOG_CONTENT=$2
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
    find ./ -mindepth 1 -maxdepth 3 -type f -name *.bz2 -mmin +43200 | xargs rm -rf
    find ./ -mindepth 1 -maxdepth 3 -type f -name *.sql -mmin +1440 | xargs rm -rf
    find ./ -mindepth 1 -maxdepth 3 -type f -name *.log -mmin +1440 | xargs rm -rf
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