#!/usr/bin/env python
## Written by MDrights, at July 12, 2017.
## Changelog
## 2018.04.07   Updated for aqi-share project (use OFTC)
## 2019.06.30   Send my OONI probe log; can send via Tor.


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
port = 6667                 # 6697
remote_ip = '207.192.72.99'

# Connect to OFTC.net 

try:
    irc.connect((remote_ip, port))

except socket.error, msg:
    print 'Failed to connect: ' + str(msg[0]) + ', Saying: ' + msg[1]
    sys.exit()

print 'Socket connected to ' + remote_ip

# Associating:

channel = "#aqi-data-share"
botnick = "CSObot"
gecos = 'A bot helping Civil Society Organisations in China.'
command = ''

irc.send("NICK " + botnick + "\n")
irc.send("USER " + gecos + "* 8 :" + gecos + "\n")
irc.send("JOIN " + channel + "\n")
#irc.send("PRIVMSG" + channel + " " + command + " " + "\n")


# Send message from files
#data = open('/tmp/aqi-latest.json', 'rU')
data = open('/tmp/run-ooniprobe.log', 'rU')

#try:
#   message = data.read()
#finally:
#    data.close()


# Receive data

while True:
    reply = irc.recv(4096)
#    print reply

    code = reply.split()
    print code

    try:
    #    if code[-7] == '366':   # Check the reversed 7th element when connecting to OFTC normally, but should check the reversed 13th element when using Tor.
        if code[-13] == '366' or code[-7] == '366':
            for message in data:
                print 'Sending Messages ...'
                irc.send("PRIVMSG" + " " + channel + " :" + message + "\r\n")
                print 'Message sent.'
            break
    except:
        pass

irc.close()
print 'Done!'


