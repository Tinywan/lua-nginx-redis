## 流媒体系统搭建

*	一、推流设备必须提前填写进后台数据库中 		

	> 概述：device_domain，也就是设备的负载均衡的地址			
	
*	二、OBS推流			

	> 流程：
	>> OBS=========>>>>>推流=========>>>>>Device_SLB	

	> 概述：OBS推流到设备负载均衡服务				

*	三、Device_SLB 设备负载均衡				

	> 流程：
	>> Device_SLB=========>>>>>负载分发到=========>>>>>DeviceServerRtmp   

	> 概述：设备负载均衡服务器根据转发策略分发到后端多台 ECS 设备流媒体服务器			

  
*	四、具体设备流媒体服务器用FFmpeg拉流到 URL_Stream 负载均衡服务器      

	> 流程：
	>> DeviceRtmp=========>>>>>FFmpeg拉流=========>>>>>URL_Stream 负载均衡   

	> 概述：设备流媒体服务器将根据RTMP执行一个shell脚本在Redis获取该设备号对应的 URL_Stream 推流负载均衡（116.62.182.199），通过FFmpeg把本地的流copy到该负载均衡去。URL_Stream负载均衡服务器根据转发策略分发到后端多台
	设备负载均衡上去( 我自己配置的Nginx负载均衡）

*	五、URL_Stream 负载均衡分发到具体的URL_Stream后端服务器
	
	> 流程：
	>> URL_Stream负载均衡服务器=========>>>>>负载分发到=========>>>>>URL_Stream后端服务器

	> 概述：URL_Stream负载均衡服务器根据转发策略分发到后端多台  ECS URL_Stream流媒体服务器

*	六、URL_Stream后端服务器分发到LiveNodeSLB负载均衡
	
	> 流程：
	>> URL_Stream后端服务器========>>>>>具体分发到=========>>>>>LiveNodeSLB节点负载均衡

	> 概述：注意：在这里的URL_Stream后端服务器分发分发的是一个数组有"|"分割的多个IP地址（该地址也就是LiveNodeSLB节点负载均衡）	

*	七、LiveNodeSLB节点负载均衡分发到具体的LiveNode
	
	> 流程：
	>> LiveNodeSLB=========>>>>>负载分发=========>>>>>LiveNode

	> 推流概述：节点负载均衡服务器LiveNodeSLB根据转发策略分发到后端多台 ECS 节点流媒体服务器，至此，流的推流、转发、分发到此结束！

*	八、CDN_proxy节点代理服务器 
	
	> 流程：
	>> 客户端请求M3U8播放=========>>>>>CDN_proxy节点代理=========>>>>>具体直播节点LiveNode	

	> 推流概述：客户端请求播放一个M3U8文件，如：http://CDN_proxy_host/hls/tinwyan123.m3u8 , 其中“tinwyan123” 表示推流名称，CDN_proxy通过虚拟服务地址执行一个LUA脚本，在该Lua脚本中
	执行一个Redis查询，查询条件的就是方才提到的“tinwyan123”（重要），根据流名称获取该流名称的直播节点LiveNode 的内网地址，返回给Nginx的Location 然后Nginx执行一个proxy_pass反向代理该具体的
	LiveNode直播节点，返回该流的播放地址
	
*	九、总结

	> 该流路径只有推流（OBS推流地址）和播流地址是外网（CDN_proxy），其余的一律使用内网走（据说不消耗流量）		 	

	
