#!/usr/bin/env ruby

$text_prompt = " >> "

print "YOUR NAME: "
$name = gets.chomp

print "RECIPIENT'S EMAIL: "
$recipient = gets.chomp

print "RECIPIENT'S IP: "
$ip = gets.chomp

$myip = %x[ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/']

$client = $myip.split('.')[3] < $ip.split('.')[3] ? true : false

def rec()
  return %x[nc -l 7777 | gpg --decrypt]
end

def send(msg)
  %x[(echo '#{enc(msg)}' | gpg --encrypt --armor --recipient #{$recipient}) | nc #{$ip} 7777]
end

def get_msg()
  pre_str = "#{$name}#{$text_prompt}"
  print pre_str
  return pre_str + gets.chomp
end

if $client then
  puts rec
end

while true do
  send(get_msg)
  puts rec
end
