#!/usr/bin/env ruby

input_array = ARGV

if input_array.length < 2
	puts "Usage: gpgcat [nickname] [recipient email] eg: gpgcat bob alice@acme.com"
	exit
end

$text_prompt = " >> "

$name = input_array[0].to_s
$recipient = input_array[1].to_s

print "Recipient's IP: "
$ip = $stdin.gets.chomp

print "(1) go first or (2) go second: "
yes = $stdin.gets.chomp

$gofirst = yes.to_i == 1 ? false : true

def rec()
	received_message = %x[nc -l 7319 | gpg --decrypt 2>&1]
	return received_message.lines.last.chomp
end

def send(msg)
	encrypted_message = %x[echo '#{msg}' | gpg --encrypt --armor --recipient #{$recipient}]
	%x[echo '#{encrypted_message}' | nc -q 1 #{$ip} 7319]
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
