#!/bin/bash
# update-new-msg.sh
# 2016.07.31
# 1.0.0 alpha

# Set file receiving original updates. 
Update="$HOME/updates1.json"
Update1="$HOME/updates1.txt"
NewMsg=$HOME/new-message.txt
IdList="$HOME/github/CSObot/id-list.txt"
Cmd_Rp="$HOME/github/CSObot/commands-reply.txt"
MsgIdNew=$HOME/message-id-new.txt
MsgIdOld=$HOME/message-id-old.txt


if [ ! -x $Idlist ];then
	touch $Idlist
fi

curl --socks5-hostname 127.0.0.1:1080 https://api.telegram.org/bot260947680:AAF87IQ2967PLVOhVWdU2xlGZnHz5_gq49o/getupdates > $Update


# Function1: Grab old chatid's message information (id & text), and send reply back.
send_msg () {
						# grab the text in new message with old chat id..
	echo "Get: $1"
	Cmd_list=`awk -F : '{ print $1 }' $Cmd_Rp`                    # Commands existed in the list.

	for c in $Cmd_list;
	do
 		Cmd_rv=`grep -o "$c" $NewMsg`
		if [ -n "$Cmd_rv" ]; then
		echo $Cmd_rv; break
		fi
	done					# Find out the command used in the message.

	Rpl="`grep "$Cmd_rv" $Cmd_Rp | awk -F : '// { print $2 ; }'`"     # Grab the correct answer.
									# Send it!
	proxychains4 w3m "https://api.telegram.org/bot260947680:AAF87IQ2967PLVOhVWdU2xlGZnHz5_gq49o/sendmessage?chat_id=$1&text=$Rpl&parse_mode=Markdown" 1&>/dev/null
	echo "$Rpl"
}


# Function2: Get new message and check if it's a new id; If it is, send a welcome message.

grab_msg () {
		# grab the new message with the new message-id.
	echo "New message: $1."
	grep "\"message_id\":$1" $Update > $NewMsg

		# Grab the new chat-id from the message.
	MsgId=`grep -o "\"chat\":{\"id\":.[0-9]*" $NewMsg | sed 's/\"chat\":{\"id\"://g'`
	echo $MsgId
		# Check if it's from a new chat-id?
	for m in `cat $IdList`
	do
		if [ "$MsgId" -eq "$m" ]; then
		echo "This is an old chat-id."; break
		else
		continue
		fi 	
	done
	if [ "$MsgId" -eq "$m" ]; then
		send_msg $MsgId            # Go to Function1 to send message back.
	else
		echo "This is an new id !"
		echo "$MsgId" >> $IdList    # Put the new id into the list.
		proxychains4 w3m "https://api.telegram.org/bot260947680:AAF87IQ2967PLVOhVWdU2xlGZnHz5_gq49o/sendmessage?chat_id=$MsgId&parse_mode=Markdown&text=Hi,there! 很高兴带上我～" 1&>/dev/null
	fi
}



# Find out new message.
## Grab message-id.

awk -F : '{ print $3 ; }' $Update | grep -o '[0-9]*' > $MsgIdNew

## Compare with the old message-id.

for i in `cat $MsgIdNew`
do
	for j in `cat $MsgIdOld`
	do
		if [ "$i" == "$j" ]; then
			break
		fi
	done
		if [ "$i" == "$j" ]; then
		continue
		else
				## call function that reply to the new message.
		echo "New one:$i"
		grab_msg $i
		fi
done

## Save new message-ids into old list.

mv $MsgIdNew $MsgIdOld


echo
exit 0
