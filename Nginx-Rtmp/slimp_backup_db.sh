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

$dumpbin $database >$databak_dir/$backup_name
/bin/bzip2 $backup_name
cd $databak_dir
# 1 mouth = 44640 min
find ./ -mindepth 1 -maxdepth 3 -type f -name *.bz2 -mmin +43200 | xargs rm -rf
find ./ -mindepth 1 -maxdepth 3 -type f -name *.sql -mmin +1440 | xargs rm -rf
echo "-------------$(date +"%y-%m-%d %H:%M:%S") backup end ----------------------" >> $logFile
