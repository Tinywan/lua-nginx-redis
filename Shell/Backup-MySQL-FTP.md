### your favorite editor, create the script file
```
vim backupdb.sh
```

```shell
#!/bin/bash

############### Infos - Edit them accordingly  ########################

DATE=`date +%Y-%m-%d_%H%M`
LOCAL_BACKUP_DIR="/backups"
DB_NAME="database_name"
DB_USER="root"
DB_PASSWORD="root_password"

FTP_SERVER="111.111.111.111"
FTP_USERNAME="ftp-user"
FTP_PASSWORD="ftp-pass"
FTP_UPLOAD_DIR="/upload"

LOG_FILE=/backups/backup-DATE.log

############### Local Backup  ########################

mysqldump -u $DB_USER  -p$DB_PASSWORD $DB_NAME | gzip  > $LOCAL_BACKUP_DIR/$DATE-$DB_NAME.sql.gz

############### UPLOAD to FTP Server  ################

ftp -nv $FTP_SERVER << EndFTP
user "$FTP_USERNAME" "$FTP_PASSWORD"
binary
cd $FTP_UPLOAD_DIR
lcd $LOCAL_BACKUP_DIR
put "$DATE-$DB_NAME.sql.gz"
bye
EndFTP

############### Check and save log, also send an email  ################

if test $? = 0
then
    echo "Database Successfully Uploaded to the Ftp Server!"
    echo -e "Database Successfully created and uploaded to the FTP Server!" | mail -s "Backup from $DATE" your_email@email.com

else
    echo "Error in database Upload to Ftp Server" > $LOG_FILE
fi
```
完成脚本编辑并保存文件后，我们可以通过以下命令使文件可执行：
```
chmod +x backupdb.sh
```
您现在可以通过在终端中输入进行测试。
```
/backups/backupdb.sh
```
完成执行后，键入ls -a以查看数据库是否已备份。还要确认它是否已发送到您的FTP服务器。

>如果到目前为止一切正常，我们可以使用Crontab使它每天运行。

## Crontab

您可以使用以下命令编辑crontab：
```
crontab -e
```
这将打开一个文本编辑器，您可以在其中输入每份工作的时间表并在新行上输入。

因此，在编辑器中，键入或粘贴以下行：
```
30 02 * * * /backups/backupdb.sh
```
上面的示例将在每月的每天的02:30 am运行/backups/backupdb.sh。当然，您可以根据需要更改时间。