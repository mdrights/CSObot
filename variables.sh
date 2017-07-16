#!/bin/bash

echo "Processing $1"
TMP="/tmp"

BotDir="$HOME/CSObot/"
Text="$TMP/bot-$1.html"
Text1="$TMP/bot-$1.1.html"
Text2="$TMP/bot-$1.2.html"
MDText="$TMP/bot-$1.md"
MDText1="$TMP/bot-$1.1.md"
Final="$TMP/bot-final.md"

Date="`date +%Y%m%d`"
Date1="`date +%Y-%m-%d`"
Date2="`date +%m-%d`"
Month="`date +%Y%m`"
Month1="`date +%Y-%m`"
Year="`date +%Y`"

