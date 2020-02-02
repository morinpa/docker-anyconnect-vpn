#!/bin/sh
echo $ANYCONNECT_PASSWORD | openconnect -u $ANYCONNECT_USER $ANYCONNECT_OPTIONS  --timestamp -b --passwd-on-stdin $ANYCONNECT_SERVER
echo "Openconnect established. Starting to ping in 30s."
sleep 30
while [ 1 ] ; do ping -c 2 $ANYCONNECT_PING ; sleep 60 ; done
