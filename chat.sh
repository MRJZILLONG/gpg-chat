#!/bin/bash

prompt=" >> "

printf "Your name: "
read name

printf "Recipient's email: "
read recipient

printf "Recipient's IP: "
read ip
theirlastoctet=$(echo $ip | cut -d '.' -f 4)

printf "(1) go first or (2) go second: "
read client

rec() {
	(nc -l 7777 | gpg --decrypt) > tmp
	tail -n 1 tmp
}

send() {
	(echo $1 | gpg --encrypt --armor --recipient $recipient)>>/dev/null | nc $ip 7777
}

get_msg() {
	pre_str="$name$text_prompt"
	printf $pre_str
	read msg
	echo $pre_str$msg
}

if [ $client = 2 ]; then
	echo `rec`
fi

while [ true ]; do
	send `get_msg`
	echo `rec`
done
