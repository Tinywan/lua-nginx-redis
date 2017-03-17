
#! /usr/bin/php
<?php
require_once './RedisInstance.class.php';
require_once './Gateway.class.php';
RedisInstance::getInstance()->setOption(\Redis::OPT_READ_TIMEOUT,-1);
RedisInstance::getInstance()->psubscribe(array('__keyevent@0__:expired'), 'psCallback');
// 回调函数,这里写处理逻辑
function psCallback($redis, $pattern, $chan, $msg)
{
	$messageId = explode(':',$msg);
	//print_r($msg);
	//echo $messageId[0]."<br/>";
	//echo $messageId[1];
	//die;
	//RedisInstance::getInstance()->set("channelXode",$messageId);
	switch($messageId[0]){
		case '4001':
			curlPost('http://127.0.0.1',array('id'=>$messageId[1]));
			break;
		case '4002':
			curlPost('http://127.0.0.1',array('id'=>$messageId[1]));
			break;
		case '4003':
                        curlPost('http://127.0.0.1',array('id'=>$messageId[1]));
                        break;
		default:
			curlPost('http://127.0.0.1',array('id'=>$msg));
			break;
	}
}

function curlPost($url, $curlPost)
{
	$curl = curl_init();

	curl_setopt($curl, CURLOPT_URL, $url);

	curl_setopt($curl, CURLOPT_HEADER, false);

	curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);

	curl_setopt($curl, CURLOPT_NOBODY, true);

	curl_setopt($curl, CURLOPT_POST, true);

	curl_setopt($curl, CURLOPT_POSTFIELDS, $curlPost);

	$return_str = curl_exec($curl);

	curl_close($curl);
	
	return $return_str;
}
