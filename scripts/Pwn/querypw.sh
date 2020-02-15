#!/bin/bash
				
# Make bash array user-rids=()

# Change user, password, and domain
user_rids=( $(rpcclient -U "user%password" -W DOMAIN.COM 10.10.10.1 -c enumdomusers | cut -d" " -f2 | cut -d":" -f2 | tr -d "[" | tr -d "]") )

# Change user, password, and domain
for i in "${user_rids[@]}"
do
	rpcclient -U "user%password" -W DOMAIN.COM 10.10.10.1 -c "queryuser $i"
done
