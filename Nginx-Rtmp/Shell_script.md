##  SHELL脚本
+   [如何不耍流氓的做运维之-SHELL脚本](http://mp.weixin.qq.com/s/aI3ha5BvzIvqpn2ddAK5zQ)
+   [已经测试成功自动备份和自动压缩备份数据库文件](https://github.com/Tinywan/Lua-Nginx-Redis/blob/master/Nginx-Rtmp/slimp_backup_db.sh)
##  SHELL脚本小技巧
```bash
#!/bin/bash
#######################################################
# $Name:         shell_template.sh
# $Version:      v1.0
# $Function:     Backup MySQL Databases Template Script
# $Author:       Jason Zhao
# $organization: https://www.unixhot.com/
# $Create Date:  2016-08-27
# $Description:  You know what i mean,hehe
#######################################################

# Shell Env
SHELL_NAME="shell_template.sh"
SHELL_DIR="/opt/shell"
SHELL_LOG="${SHELL_DIR}/${SHELL_NAME}.log"
LOCK_FILE="/tmp/${SHELL_NAME}.lock"

#Write Log 
shell_log(){
    LOG_INFO=$1
    echo "$(date "+%Y-%m-%d") $(date "+%H-%M-%S") : ${SHELL_NAME} : ${LOG_INFO}" >> ${SHELL_LOG}
}

# Shell Usage shell_usage函数，用来告诉用户，这个脚本的使用方法
shell_usage(){
    echo $"Usage: $0 {backup}"
}

#   函数shell_lock和shell_unlock非常简单，就是创建一个锁文件
shell_lock(){
    touch ${LOCK_FILE}
}

shell_unlock(){
    rm -f ${LOCK_FILE}
}

# Backup MySQL All Database with mysqldump or innobackupex
mysql_backup(){
    if [ -f "$LOCK_FILE" ];then
        shell_log "${SHELL_NAME} is running"
        echo "${SHELL_NAME}" is running && exit
    fi
    shell_log "mysql backup start"
    shell_lock
    sleep 10
    shell_log "mysql backup stop"
    shell_unlock
}

# Main Function
main(){
    case $1 in
        backup)
            mysql_backup
            ;;
        *)
            shell_usage;
    esac
}

#Exec
main $1
```