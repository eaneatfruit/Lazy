#!/usr/bin/bash

# Current Connections

conn=$(netstat -tulpn -A inet | grep -vE '^Active|Proto' | grep 'LISTEN' | awk '{ print $4 }')
my_arr=($conn)

for i in "${my_arr[@]}"
do
	if [ $i == "127.0.0.1:11211" ]
	then
		python /root/notify.py
	fi
done

