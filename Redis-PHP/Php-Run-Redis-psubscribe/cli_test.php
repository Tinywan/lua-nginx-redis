<?php
$count = 0;
sleep(10);
while (true) {
    $count++;
    $ch = curl_init() or die (curl_error());
    curl_setopt($ch, CURLOPT_URL, $argv[1]);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "GET");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 1);
    $response = curl_exec($ch);
    curl_close($ch);
    if ($count > 1000) {
        break;
    }
    //解析JSON字符串为数组
    $res = json_decode($response, true);
    //如果客户端返回数据为0 则表示接收到数据了
    if ($res[0] == '0') {
        break;
    }
    continue;
}
exit(1);
