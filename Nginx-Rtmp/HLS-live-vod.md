### Nginx配置Rtmp支持Hls的直播和点播功能
>[参考网址：https://www.vultr.com/docs/setup-nginx-on-ubuntu-to-stream-live-hls-video](https://www.vultr.com/docs/setup-nginx-on-ubuntu-to-stream-live-hls-video)

>配置信息
```
worker_processes  1;
error_log  logs/error.log debug;
events {
    worker_connections  1024;
}
rtmp {
    server {
        listen 1935;
        allow play all;
        notify_method get;     

        #creates our "live" full-resolution HLS videostream from our incoming encoder stream and tells where to put the HLS video manifest and video fragments
        application live {
            allow play all;
            live on;
            on_publish http://example.com/openapi/on_publish_done;   # 设置开始推流的回调
            record all;
            record_path /home/tinywan/video_recordings;
            record_unique on;
            on_record_done http://example.com/recorded; # 设置录像结束的回调
            hls on;
            hls_nested on;
            hls_path /HLS/live;
            hls_fragment 10s;
            on_publish_done http://example.com/on_publish_done;  # 设置开始推流的回调

            #creates the downsampled or "trans-rated" mobile video stream as a 400kbps, 480x360 sized video
            exec ffmpeg -i rtmp://192.168.254.178:1935/$app/$name -acodec copy -c:v libx264 -preset veryfast -profile:v baseline -vsync cfr -s 480x360 -b:v 400k maxrate 400k -bufsize 400k -threads 0 -r 30 -f flv rtmp://192.168.254.178:1935/mobile/$;
        }

        #creates our "mobile" lower-resolution HLS videostream from the ffmpeg-created stream and tells where to put the HLS video manifest and video fragments
        application mobile {
            allow play all;
            live on;
            hls on;
            hls_nested on;
            hls_path /home/tinywan/HLS/mobile;
            hls_fragment 10s;
        }

        #allows you to play your recordings of your live streams using a URL like "rtmp://my-ip:1935/vod/filename.flv"
        application vod {
            play /home/tinywan/video_recordings;
        }
    }
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    server {
        listen 80;
        server_name 192.168.254.178;

        #creates the http-location for our full-resolution (desktop) HLS stream - "http://my-ip/live/my-stream-key/index.m3u8"      
        location /live {
            types {
                application/vnd.apple.mpegurl m3u8;
            }
            alias /home/tinywan/HLS/live;
            add_header Cache-Control no-cache;
        }

        #creates the http-location for our mobile-device HLS stream - "http://my-ip/mobile/my-stream-key/index.m3u8"        
        location /mobile {
            types {
                application/vnd.apple.mpegurl m3u8;
            }
            alias /home/tinywan/HLS/mobile;
            add_header Cache-Control no-cache;
        }   

        #allows us to see how stats on viewers on our Nginx site using a URL like: "http://my-ip/stats"     
        location /stats {
            stub_status;
        }

        #allows us to host some webpages which can show our videos: "http://my-ip/my-page.html"     
        location / {
            root   html;
            index  index.html index.htm;
        }   
    }
}
```
## 播放测试结果
+   M3U8播放
    ```
    http://192.168.18.151/live/123456/index.m3u8
    ```
+   RTMP播放
    ```
    rtmp://192.168.18.151/live/123456
    ```
+   点播播放
    ```
    rtmp://192.168.18.151/vod/123456-1490768694.flv
    ```        
    # m3u8: 
## 统计
+   使用Nginx统计信息（使用Nginx stub_status）。要查看访客/观众统计资料
    + 浏览器测试
    ```
    http://192.168.18.151/stats
    ```    
    + 结果信息
    ```
    Active connections: 1 
    server accepts handled requests
    274 274 108 
    Reading: 0 Writing: 1 Waiting: 0 
    ```
## 回调信息
+   on_publish 
    + 上下文：rtmp, server, application
    + 返回参数参考
    ```
    $action = $_GET['call'];                    --  publish
    $appName = $_GET['app'];                    --  live
    $swfurl = $_GET['swfurl'];                  --  http://123213.com/lib/jwplayer/jwplayer.flash.swf
    $tcurl = $_GET['tcurl'];                    --  rtmp://11.26.11.11/live/
    $ip = $_GET['addr'];                        --  客户端IP地址
    $clientid = $_GET['clientid'];              --  871696
    $streamName = $_GET['name'];                --  stream123            
    ```    
+   on_publish_done 
    + 上下文：rtmp, server, application
    + 返回参数参考
    ```
    $action = $_GET['call'];                    --  on_publish_done
    $appName = $_GET['app'];                    
    $swfurl = $_GET['swfurl'];                   
    $tcurl = $_GET['tcurl'];                    
    $ip = $_GET['addr'];                   
    $clientid = $_GET['clientid'];                    
    $streamName = $_GET['name'];                               
    ```  
+   on_record_done (on_record_done http://my-ip/api/recordDone;) 
    + 上下文：rtmp, server, application, recorder
    + 返回参数参考
    ```
    'app' => string 'live' (length=4)
    'flashver' => string 'FMLE/3.0 (compatible; Lavf56.3.' (length=31)
    'swfurl' => string '' (length=0)
    'tcurl' => string 'rtmp://10.117.19.148:1935/live' (length=30)
    'pageurl' => string '' (length=0)
    'addr' => string '192.168.18.151/' (length=13)
    'clientid' => string '1' (length=1)
    'call' => string 'record_done' (length=11)                              -- 录像事件状态
    'recorder' => string 'rec1' (length=4)                                  -- 录像模块名称
    'name' => string '123456' (length=13)                                   -- 推流名称
    'path' => string '/home/tinywan/video_recordings/123456-1482801335.flv' -- 录像路径                      
    ```              
    + RTMP配置信息，在这里，定义了一个录像模块，这样的话不会自动录像
    ```
    rtmp {
        server {
            listen 1935;
            ping 30s;
            notify_method get;
            application live {
                live on;
                on_record_done http://my-ip/api/recordDone;                    -- 以上配置在这里个回调里面的地址
                recorder rec1 {
                        record all manual;
                        record_unique on;
                        record_notify on;
                        record_path /data/recorded_flvs;
                        exec_record_done /home/www/bin/rtmpRecordedNotify.sh $name $path $filename $basename $dirname;
            }
        }
    }
    ```

+   on_connect 
    + 上下文：rtmp, server
    + 返回参数参考
    ```
        'app' => string 'live' (length=4)
        'flashver' => string '' (length=0)
        'swfurl' => string '' (length=0)
        'tcurl' => string 'rtmp://192.168.18.151/live' (length=25)
        'pageurl' => string '' (length=0)
        'addr' => string '10.117.64.209' (length=13)
        'epoch' => string '582057759' (length=9)
        'call' => string 'connect' (length=7)                              
    ```      

+   实际案例 (Web页面和Mobile手机流转换)      
    ```
        rtmp {
            server {
                listen 1935;   
                application live {
                    live on;
                    exec ffmpeg -i rtmp://localhost/live/$name -acodec copy -c:v libx264 -preset veryfast -profile:v baseline -vsync cfr -s 480x360 -b:v 400k -bufsize 400k -threads 0 -r 30 -f flv rtmp://localhost/mobile/$name;
                }

                application mobile {
                    allow play all;
                    live on;
                    hls on;
                    hls_nested on;
                    hls_path /home/tinywan/HLS/mobile;
                    hls_fragment 10s;
                }
            }
        }
    ```

>实际案例 2

>实际案例 3    