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

        #creates our "live" full-resolution HLS videostream from our incoming encoder stream and tells where to put the HLS video manifest and video fragments
        application live {
            allow play all;
            live on;
            record all;
            record_path /video_recordings;
            record_unique on;
            hls on;
            hls_nested on;
            hls_path /HLS/live;
            hls_fragment 10s;

            #creates the downsampled or "trans-rated" mobile video stream as a 400kbps, 480x360 sized video
            exec ffmpeg -i rtmp://192.168.254.178:1935/$app/$name -acodec copy -c:v libx264 -preset veryfast -profile:v baseline -vsync cfr -s 480x360 -b:v 400k maxrate 400k -bufsize 400k -threads 0 -r 30 -f flv rtmp://192.168.254.178:1935/mobile/$;
        }

        #creates our "mobile" lower-resolution HLS videostream from the ffmpeg-created stream and tells where to put the HLS video manifest and video fragments
        application mobile {
            allow play all;
            live on;
            hls on;
            hls_nested on;
            hls_path /HLS/mobile;
            hls_fragment 10s;
        }

        #allows you to play your recordings of your live streams using a URL like "rtmp://my-ip:1935/vod/filename.flv"
        application vod {
            play /video_recordings;
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
            alias /HLS/live;
            add_header Cache-Control no-cache;
        }

        #creates the http-location for our mobile-device HLS stream - "http://my-ip/mobile/my-stream-key/index.m3u8"        
        location /mobile {
            types {
                application/vnd.apple.mpegurl m3u8;
            }
            alias /HLS/mobile;
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
    