#!/usr/bin/env ruby

$text_prompt = " >> "

print "YOUR NAME: "
$name = gets.chomp

print "RECIPIENT'S EMAIL: "
$recipient = gets.chomp

print "RECIPIENT'S IP: "
$ip = gets.chomp

print "MY IP: "
$myip = gets.chomp

$client = $myip.split('.')[3] < $ip.split('.')[3] ? true : false

def rec()
	a = %x[(nc -l 7777 | gpg --decrypt)]
	%x[echo "#{a}" | tail -n 1]
end

def send(msg)
	%x[(echo "#{msg}" | gpg --encrypt --armor --recipient #{$recipient}) | nc #{$ip} 7777]
end

def get_msg()
	pre_str = "#{$name}#{$text_prompt}"
	print pre_str
	pre_str + gets.chomp
end

if $client then
	puts rec
end

while true do
	send(get_msg)
	puts rec
end
