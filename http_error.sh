#!/bin/bash
#Author:bearchess

url=http://www.baidu.com #访问网址
dingdinghook=#钉钉机器人 webhook
mailList=(
test@qq.cn
) #邮件列表

SendMsgToDingding(){
curl $dingdinghook -H 'Content-Type: application/json' -d "
    {
        'msgtype': 'text',
        'text': {
            'content': '报警地址：$url\n告警信息：语音服务返回值异常 code<$status_code> 请注意\n'
        },
        'at': {
            'isAtAll': true
        }
    }"
}

SendMsgToMail(){
	for(( i=0;i<${#mailList[@]};i++)) do
		#echo ${array[i]};
		echo "       报警地址：$url 
		   告警信息：语音服务返回值异常 code<$status_code> 请注意" | mail -s "语音服务报警" ${mailList[i]} #mail需要去/etc/mail.rc配置 
	done
}

check_http(){
status_code=`curl -I  -m  10  -o  /dev/null  -s  -w  %{http_code}  $url`
#status_code=$(curl -I  -m  10  -o  /dev/null  -s  -w  %{http_code}  $url) 
}



while :
do
	check_http
	code=$status_code
	date=$(date +%Y%m%d-%H:%M:%S) 
	echo "$date $status_code"
	if  [ $code = "200" ];then
		echo "right"
	else
		echo "wrong"
		SendMsgToDingding	
		SendMsgToMail
	fi
sleep 10
done
