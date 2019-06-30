#!/bin/bash
#

. $HOME/CSObot/variables.sh

# Clean the information collected last time:
cat /dev/null > $Final

# Choose what script you want to execute:

. $BotDir/ngo/bot-ngocn.sh

. $BotDir/gov/bot-sz.sh

# Sent the information to IRC channel:

/usr/bin/python2 $BotDir/irc-client.py
