#!/bin/bash
SUBDOMAIN=$2
IP=192.168.138.3
COMMAND=$1
KEYFILE="ddns.key"
FILE="input.txt"

PRIMARY_NS="ns1.focus.my"
ZONE="focus.my"


#COMMAND
ECHO=$(which echo)
NSUPDATE=$(which nsupdate)



$ECHO "server $PRIMARY_NS" 				> $FILE
#$ECHO "debug yes" 					>>$FILE
$ECHO "zone $ZONE"					>>$FILE
$ECHO "update $COMMAND $SUBDOMAIN.$ZONE 60 A $IP" 	>>$FILE
$ECHO "send" 						>>$FILE

$NSUPDATE -k $KEYFILE -v $FILE 2>&1
