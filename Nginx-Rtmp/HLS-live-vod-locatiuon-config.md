### HLS视频直播和点播的Nginx的Location的配置信息

+ 配置信息
    ```
    http {
        include       mime.types;
        default_type  application/octet-stream;
        server {
            listen 80;
            server_name 127.0.0.1;
            root   /home/tinywan;
            error_log logs/rewrite_error.log notice;

            # HLS Live
            location ^~ /live/ {
                add_header Cache-Control no-cache;
                add_header 'Access-Control-Allow-Origin' '*' always;
                add_header 'Access-Control-Allow-Credentials' 'true';
                add_header 'Access-Control-Expose-Headers' 'Content-Length,Content-Range';
                add_header 'Access-Control-Allow-Headers' 'Range';

                types{
                    application/dash+xml mpd;
                    application/vnd.apple.mpegurl m3u8;
                    video/mp2t ts;
                }
            root /home/tinywan/HLS;
            }

            # History Video m3u8&mp4
            location ^~ /video_recordings/ {
                add_header Cache-Control no-cache;
                add_header 'Access-Control-Allow-Origin' '*' always;
                add_header 'Access-Control-Allow-Credentials' 'true';
                add_header 'Access-Control-Expose-Headers' 'Content-Length,Content-Range';
                add_header 'Access-Control-Allow-Headers' 'Range';

                types{
                    application/dash+xml mpd;
                    application/vnd.apple.mpegurl m3u8;
                    video/mp2t ts;
                }
                alias /home/tinywan/video_recordings/;
            }

    }
    }
    ```
+ 直播
    +   OBS推流地址：`rtmp://192.168.18.143/live/tinywan123`
    +   RTMP直播地址：`rtmp://192.168.18.143/live/tinywan123`
    +   HLS直播：`http://192.168.18.143/live/tinywan123/index.m3u8`
    +   OBS推流地址：`rtmp://192.168.18.143/live/tinywan123`
+ 点播
    +  MP4点播： `rtmp://192.168.18.143/vod/tinywan123-149190255220170411172232.mp4`
+ 回顾
    +  HLS回顾地址： `http://192.168.18.143/video_recordings/tinywan123-149179459020170410112310/index.m3u8`   
    +  MP4回顾地址： `http://192.168.18.143/video_recordings/tinywan123-149179459020170410112310.mp4`    
+ 