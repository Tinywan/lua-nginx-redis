#!/bin/bash
:<<tinywan
        [1]author:Tinywan
        [2]log_format:
		[0] 语法格式：echo -e "\033[31m $msg \033[0m" >>log_file.log
		[1] error===>红色(31m)：错误日志信息
		[2] info===>绿色(32m)：命令成功执行、URL回调成功、打印正确数据信息
		[3] warn===>黄色(33m)：参数不存在、文件不存在、命令拼写错误
		[3] debug===>Blue色(34m)： debug
        [3]date:2016-11-04 10:23:10 [date '+%Y-%m-%d %H:%M:%S']
tinywan

PATH=/usr/local/bin:/usr/bin:/bin
YM=`date +%Y%m`
FLOG=/home/tinywan/bin/recorded_${YM}.log
#设置日志级别
loglevel=0 #debug:0; info:1; warn:2; error:3
TIME=`date '+%Y-%m-%d %H:%M:%S'`
function LOG(){
	local log_type=$1
	local LOG_CONTENT=$2
	logformat="${TIME} \t[${log_type}]\tFunction: ${FUNCNAME[@]}\t[line:`caller 0 | awk '{print$1}'`]\t [log_info: ${LOG_CONTENT}]"
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
        } | tee -a $FLOG
}

echo -e  "\r\n \033[34m------------------------------------------------------Shell Script Start -------------------------------------------- \033[0m " >> $FLOG
# 最小视频长度
MIN_DURATION=20

# Redis Var 
REDIS_HOST='127.0.0.1'
REDIS_PORT='6379'
REDIS_AUTH='tinywanredis'
REDIS_DB=12

# 推流名称 mystream
STREAM_NAME=$1

# 录制文件全路径 /tmp/rec/mystream-1389499351.flv
FULL_NAME=$2

# 录制文件名 mystream-1389499351.flv
FILE_NAME=$3

# 录制文件名，不带后缀(mystream-1389499351)
BASE_NAME=$4

# 录制文件路径  /tmp/rec
DIR_NAME=$5

# -z 检测字符串长度是否为0 # 检测 STREAM_NAME 变量值是否为空
if [ -z "${STREAM_NAME}" ];then
	LOG error "STREAM_NAME is null"
	exit 1
fi

# $@ 是传给脚本的所有参数的列表
#echo -e "\033[32m [SUCCESS][$TIME]: $@ \033[0m" >>$FLOG
LOG debug $@

# 检测 FULL_NAME 变量值是否为空
if [ -z "${FULL_NAME}" ]; then
	LOG error "FULL_NAME is null"
	exit 1
fi

# 检测文件是否存在并且大小不为0
if [ ! -s "${FULL_NAME}" ]; then
	LOG error "File not exists or zero size "
	# 文件为空文件删除掉该文件
	rm -f ${FULL_NAME}
	exit 1
fi

# 检测视频时长，小于 MIN_DURATION 的文件将被丢弃
DURATION=`ffmpeg -i ${FULL_NAME} 2>&1 | awk '/Duration/ {split($2,a,":");print a[1]*3600+a[2]*60+a[3]}'`
if [ $(echo "$duration < $MIN_DURATION"|bc) = 1 ]; then
	LOG error" Duration too short, FULL_NAME=${FULL_NAME}, DURATION==${DURATION}"
	rm -f ${FULL_NAME}
	exit 1
fi

#echo "[DEBUG1][$TIME] Video Record :  FULL_NAME=$FULL_NAME, FULL_NAME=${FULL_NAME}, DURATION=${DURATION}" >> $FLOG

# 自动截取封面图片
/usr/bin/ffmpeg -y -ss 00:00:10 -i ${FULL_NAME} -vframes 1 ${DIR_NAME}/${BASE_NAME}.jpg

# 转码成MP4
/usr/bin/ffmpeg -y -i ${FULL_NAME} -vcodec copy -acodec copy ${DIR_NAME}/${BASE_NAME}.mp4

# 获取文件大小
FILE_SIZE=`stat -c "%s" ${DIR_NAME}/${BASE_NAME}.mp4`

# 获取视频录制时间
FILE_TIME=`stat -c "%Y" ${FULL_NAME}`

LOG debug "Video: FILE_NAME=${FILE_NAME}, DURATION=${DURATION}, FILESIZE=${FILE_SIZE},FILETIME=${FILE_TIME}"

#recorded done rallback
URL="http://sewise.amai8.com/openapi/recordDone?streamName=${STREAM_NAME}&baseName=${BASE_NAME}&duration=${DURATION}&fileSize=${FILE_SIZE}&fileTime=${FILE_TIME}" 
RESULT=$(curl ${URL} 2>/dev/null)

if [ "${RESULT}" != "200" ]; then
	LOG error "recorded rallBakc Error ${STREAM_NAME}"
else
	LOG info "recorded rallBakc OK ${STREAM_NAME}"	
fi

# auto slice mp4 to m3u8
mkdir -p ${DIR_NAME}/${BASE_NAME}

/usr/bin/ffmpeg -i ${FULL_NAME} -flags +global_header -f segment -segment_time 3 -segment_format mpegts -segment_list ${DIR_NAME}/${BASE_NAME}/index.m3u8 -c:a copy -c:v copy -bsf:v h264_mp4toannexb -map 0 ${DIR_NAME}/${BASE_NAME}/%5d.ts

LOG info "slice OK"
#LOG warn "${TIME}"
exit 1



