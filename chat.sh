#!/bin/bash

prompt=" >> "

printf "Your name: "
read name

printf "Recipient's email: "
read recipient

printf "Recipient's IP: "
read ip
theirlastoctet=$(echo $ip | cut -d '.' -f 4)

myip=`(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')`
mylastoctet=$(echo $myip | cut -d . -f 4)

client=$([ $mylastoctet > $theirlastoctet ] && echo "true" || echo "false")

rec() {
	(nc -l 7777 | gpg --decrypt) | tail -1
}

send() {
	(echo $1 | gpg --encrypt --armor --recipient $recipient) | nc $ip 7777
}

get_msg() {
	pre_str=$name$text_prompt
	printf $pre_str
	read msg
	$pre_str$msg
}

if [ $client ]; then
	echo `rec`
fi

while [ true ]; do
	send `get_msg`
	echo `rec`
done
