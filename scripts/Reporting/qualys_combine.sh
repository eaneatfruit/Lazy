#!/bin/sh

# This script combines qualys .csv scans that are in the current working directory into a single csv ready for creating a table and pivot tables.
# How it works: Remove the first 8 lines (qualys scan information such as start time), removes the last (blank) line of the csv, then combines all .csv's into a single output.csv file. for the first file it doesnt remove the column headers.
# Usage: no paramters. just call the script. ./qualys_combine.sh


ls | grep .csv > csvlist.txt

touch output.csv

count=0

for i in $(cat csvlist.txt);
do 
	if [ $count -eq 0 ] 
	then
		
		sed -e '$ d' $i | tail -n +8 >> output.csv
	else
		sed -e '$ d' $i | tail -n +9 >> output.csv
	fi
	
	((count++))
done

echo 'done!'
