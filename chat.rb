#!/usr/bin/env ruby

require "shellwords"

$text_prompt = " >> "

print "YOUR NAME: "
$name = gets.chomp

print "RECIPIENT'S EMAIL: "
$recipient = gets.chomp

print "RECIPIENT'S IP: "
$ip = gets.chomp

print "(1) go first or (2) go second: "
yes = gets.chomp
$gofirst = yes.to_i == 1 ? false : true

def rec()
	received_message = %x[nc -l 7777 | gpg --decrypt 2>&1]
	return received_message.lines.last.chomp
end

def send(msg)
	encrypted_message = Shellwords.escape(%x[echo '#{msg}' | gpg --encrypt --armor --recipient #{$recipient}])
	%x[echo '#{encrypted_message}' | nc #{$ip} 7777]
end

def get_msg()
	pre_str = "#{$name}#{$text_prompt}"
	print pre_str
	return pre_str + gets.chomp
end

if $gofirst then
	puts rec
end

while true do
	send(get_msg)
	puts rec
end
