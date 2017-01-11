#!/usr/bin/env ruby

$text_prompt = " >> "

print "YOUR NAME: "
$name = gets.chomp

print "RECIPIENT'S EMAIL: "
$recipient = gets.chomp

print "RECIPIENT'S IP: "
$ip = gets.chomp

$myip = %x[ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/']

# THE ONE WITH HIGHER IP WILL BE THE SERVER
$client = $myip.split('.')[3] > $ip.split('.')[3] ? false : true
$cmd = $client ? "nc #{$ip} 5555 -w 120" : "nc -l 5555"

def enc(msg, recipient)
  return  %x[echo '#{msg}' | gpg --encrypt --armor --recipient #{recipient}]
end

def dec(msg)
  return %x[echo '#{msg}' | gpg --decrypt --armor]
end

def rec()
  return dec(%x[#{$cmd}])
end

def send(msg)
  %x[echo '#{enc(msg, $recipient)}' | #{$cmd}]
  return "#{$name}: #{msg}"
end

def get_msg()
  pre_str = "#{$name}#{$text_prompt}"
  print pre_str
  return pre_str + gets.chomp
end


def one()
  puts send(get_msg)
end

def two()
  puts rec
end

if $client then
  two()
end

while true do
  one()
  two()
end
