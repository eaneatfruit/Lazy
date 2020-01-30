#!/bin/bash
zone=$1
echo "Segtest @ $zone"

echo "$zone to Zone1"
sudo nmap -sS -T5 -Pn -iL zone2-ips.txt -oA ${zone}-zone1.txt
echo "$zone to Zone2"
sudo nmap -sS -T5 -Pn -iL zone1-ips.txt -oA ${zone}-to-zone2
echo "$zone to internet"
sudo nmap -sS -p1-65535 -T4 -Pn egadz.metasploit.com -oA ${zone}-to-internet
