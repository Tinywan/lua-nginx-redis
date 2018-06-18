## PHP 和 Shell 如何很好的搭配  

## shell 脚本  
```bash
#!/bin/bash
#######################################################
# $Name:         check_oss_cut.sh
# $Author:       ShaoBo Wan (Tinywan)
# $organization: https://github.com/Tinywan
#######################################################

if [ $# -ne 3 ] ; then
        echo 1 ; // 注意这个值才是php 执行函数接受到的返回值，而不是 exit
        exit 1;
fi

if [ $# -ne 6 ] ; then
        echo 2 ;
        exit 2;
fi

exit 0;
```

## PHP 脚本  
```php
    /**
     * 脚本没有执行权限 Permission denied
     */
    const PERMISSION = 126;

    /**
     * 需要使用dos2unix命令将文件转换为unix格式
     * eg：dos2unix file
     */
    const DOS2UNIX = 127;

    /**
     * 脚本内部命令执行错误
     */
    const INTERNAL_ERROR = 247;

    const OUTPUT_MSG = [
      0 => 'success',
      1 => 'API Sign Error , Please task_id',
      2 => 'Oss File Download Fail',
      3 => 'FFmpeg cut/concat Video Fail',
      4 => 'Rename file error, Disk is full',
      5 => '截取缩略图失败，请检查视频开始、结束、视频截图时间',
    ];

    /**
     * 在退出时使用不同的错误码
     */
    public function phpRunShellScript()
    {
        // 脚本路径
        $scriptPath = $_SERVER['DOCUMENT_ROOT'] . "/shell/php-test.sh";
        $scriptParam = '1 2 8';
        $cmdStr = "{$scriptPath} {$scriptParam}";
        echo $cmdStr;
        // 执行
        exec("{$cmdStr}", $output_result, $return_status);

        // 返回码判断
        if($return_status == self::PERMISSION ){
            echo "chmod u+x ".$scriptPath."<br/>";
        }elseif ($return_status == self::DOS2UNIX){
            echo "需要使用dos2unix命令将文件转换为unix格式 <br/>";
        }else{
            // 这时候要根据脚本返回的第二个返回值判断脚本具体哪里出错误了
            echo "脚本执行异常 MSg ：" . $return_status . "<br/>";
            if ( isset($output_result[1]) && $output_result[1] == 1) {
                echo " MSg1 : ".self::OUTPUT_MSG[$output_result[1]]."<br/>";
            } elseif (isset($output_result[1]) && $output_result[1] == 2){
                echo " MSg2 : ".self::OUTPUT_MSG[$output_result[1]]."<br/>";
            } elseif (isset($output_result[1]) && $output_result[1] == 3){
                echo " MSg3 : ".self::OUTPUT_MSG[$output_result[1]]."<br/>";
            }
        }
        echo 'success';
    }
```


