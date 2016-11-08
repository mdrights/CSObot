#!/bin/bash

Token=260947680:AAF87IQ2967PLVOhVWdU2xlGZnHz5_gq49o

curl --globoff "https://api.telegram.org/bot$Token/sendmessage?chat_id=64960773&parse_mode=Markdown&text=test"

exit

