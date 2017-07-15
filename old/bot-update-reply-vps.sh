#!/bin/bash
# bot-update-reply-vps.sh (for formal vps use)
# 2016.07.31
# Modified at 2016.11.08

# Set file receiving original updates. 
BotDir="$HOME/CSObot"                    # May subject to change in other machines.
Update="$BotDir/updates1.json"
Update1="$BotDir/updates1.txt"
NewMsg="$BotDir/new-message.txt"
IdList="$BotDir/id-list.txt"
Cmd_Rp="$BotDir/commands-reply.txt"
MsgIdNew="$BotDir/message-id-new.txt"
MsgIdOld="$BotDir/message-id-old.txt"


## Start -----------------------------

if [ ! -x $Idlist ];then
	touch $Idlist
fi

curl https://api.telegram.org/bot260947680:AAF87IQ2967PLVOhVWdU2xlGZnHz5_gq49o/getupdates > $Update


# Function1: Grab old chatid's message information (id & text), and send reply back.
send_msg () {
						# grab the text in new message with old chat id..
	echo "Get: $1"
	Cmd_list=`awk -F : '{ print $1 }' $Cmd_Rp`                    # Commands existed in the list.

        for c in $Cmd_list;                                           # Find out the command used in the message.
        do
                Cmd_rv=`grep -o "$c" $NewMsg`
                if [ -n "$Cmd_rv" ]; then
                echo $Cmd_rv 
                Rpl="`grep "$Cmd_rv" $Cmd_Rp | awk -F : '{ print $2 ; }'`"     # Grab the correct answer.
                w3m "https://api.telegram.org/bot260947680:AAF87IQ2967PLVOhVWdU2xlGZnHz5_gq49o/sendmessage?chat_id=$1&text=$Rpl&parse_mode=Markdown" 1&>/dev/null
                break
                fi
        done
						# Check and response to feedback (not commands). If it is, send it to me.
        if [ -z "$Cmd_rv" ]; then
        Feedbk=`grep -o "text\":\".*\"" $NewMsg`
        echo "There is a feedback: $Feedbk."
                w3m "https://api.telegram.org/bot260947680:AAF87IQ2967PLVOhVWdU2xlGZnHz5_gq49o/sendmessage?chat_id=64960773&text=$Feedbk&parse_mode=Markdown" 1&>/dev/null

        fi

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
		if [ "$MsgId" == "$m" ]; then
		echo "This is an old chat-id."; break
		else
		continue
		fi 	
	done
	if [ "$MsgId" == "$m" ]; then
		send_msg $MsgId            # Go to Function1 to send message back.
	else
		echo "This is an new id !"
		echo "$MsgId" >> $IdList    # Put the new id into the list.
		w3m "https://api.telegram.org/bot260947680:AAF87IQ2967PLVOhVWdU2xlGZnHz5_gq49o/sendmessage?chat_id=$MsgId&parse_mode=Markdown&text=Hi,there! 很高兴带上我～" 1&>/dev/null
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
