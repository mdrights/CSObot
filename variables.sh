#!/bin/bash

echo "Processing $1"

BotDir="$HOME/CSObot/"
Text="$HOME/bot-$1.html"
Text1="$HOME/bot-$1.1.html"
Text2="$HOME/bot-$1.2.html"
MDText="$HOME/bot-$1.md"
MDText1="$HOME/bot-$1.1.md"

Date="`date +%Y%m%d`"
Date1="`date +%Y-%m-%d`"
Date2="`date +%m-%d`"
Month="`date +%Y%m`"
Month1="`date +%Y-%m`"
Year="`date +%Y`"

