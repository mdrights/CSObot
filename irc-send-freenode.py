#!/usr/bin/env python
## Written by MDrights, at July 12, 2017.
## Changelog
# 2019.06.30    revised.


import socket
import sys

# Create a Socket

try:
    irc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

except socket.error:
    print 'Failed to create socket'
    sys.exit()


print 'Socket Created.'

host = ''
port = 6667
remote_ip = '94.125.182.252'

# Connect to the freenode

try:
    irc.connect((remote_ip, port))

except socket.error, msg:
    print 'Failed to connect: ' + str(msg[0]) + ', Saying: ' + msg[1]
    sys.exit()

print 'Socket connected to ' + remote_ip

# Associating:

channel = "#digitalrightscn"
botnick = "CSObot"
gecos = 'A bot helping Civil Society Organisations in China.'
command = ''

irc.send("NICK " + botnick + "\n")
irc.send("USER " + gecos + "* 8 :" + gecos + "\n")
irc.send("JOIN " + channel + "\n")
#irc.send("PRIVMSG" + channel + " " + command + " " + "\n")


# Send message from files

data = open('/tmp/bot-final.md', 'rU')

#try:
#   message = data.read()
#finally:
#    data.close()


# Receive data

while True:
    reply = irc.recv(4096)
#    print reply

    code = reply.split()
#    print code[1]

    if code[1] == '353':
        for message in data:
            print 'Sending: ' + message
            irc.send("PRIVMSG" + " " + channel + " :" + message + "\r\n")
            #print 'Message sent.'
        break

irc.close()
print 'Done!'


