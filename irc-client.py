#!/usr/bin/env python
## Written by MDrights, at July 12, 2017.
## Version 0.0

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

# channel = "#gentoowithoutjuju"
channel = "#publipolicy-cn"
botnick = "CSObot"
gecos = 'A bot helping Civil Society Organisations in China.'
command = ''

irc.send("NICK " + botnick + "\n")
irc.send("USER " + gecos + "* 8 :" + gecos + "\n")
irc.send("JOIN " + channel + "\n")
#irc.send("PRIVMSG" + channel + " " + command + " " + "\n")

# Send message from files

# data = open('xxxxxx', 'rU')

#try:
#    message = data.read()
#finally:
#    data.close()


# Receive data

while True:
    reply = irc.recv(4096)
    print reply

    message = "I am a silly bot."

    try:
        irc.send("PRIVMSG" + " " + channel + " :" + message + "\r\n")
    except socket.error, msg:
        print 'Oops, failed: ' +  str(msg[0]) + ': ' + msg[1]
        sys.exit()
    finally:
        print 'Message sent successfully.'

irc.close()


