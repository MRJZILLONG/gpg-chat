#!/usr/bin/env ruby

$text_prompt = " >> "

print "Nickname: "
$name = gets.chomp

print "Recipient's Email: "
$recipient = gets.chomp

print "Recipient's IP: "
$ip = gets.chomp

print "(1) go first or (2) go second: "
yes = gets.chomp
$gofirst = yes.to_i == 1 ? false : true

def rec()
	received_message = %x[nc -l 7319 | gpg --decrypt 2>&1]
	return received_message.lines.last.chomp
end

def send(msg)
	encrypted_message = %x[echo '#{msg}' | gpg --encrypt --armor --recipient #{$recipient}]
	%x[echo '#{encrypted_message}' | nc #{$ip} 7319]
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
