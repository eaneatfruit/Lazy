#!/bin/bash

if [[ $# -eq 0 ]]; then
        echo 'Takes a gnmap file as input, and extracts common ports and puts each ip into separate files by common service name.'
        echo ''
        echo '"smb_extractor.sh nmap.gnmap"'
        exit
fi

file=$1

# TCP Services
declare -i ftpCount
declare -i sshCount
declare -i telnetCount
declare -i smtpCount
declare -i rpcCount
declare -i smbCount
declare -i mssql
declare -i nfsCount
declare -i sql
declare -i httpCount
declare -i httpsCount
declare -i rdpCount
declare -i ldapCount

#UDP Services
declare -i dnsCount
declare -i snmpCount
declare -i syslogCount


cat $file | grep 'Host' | grep open > nmap_extractor_result

while read i; do
	ip="$(echo $i | grep "open/" | sed -e 's/Host: //g' -e 's/ (.*//g')"

	ports="$(echo $i | cut -d ':' -f 3- | tr ',' '\n' | tr ' ' '.')"


	for service in $(echo $ports); do
		port="$(echo $service | cut -d '/' -f 1| cut -d '.' -f2)"
		portStatus="$(echo $service | cut -d '/' -f2)"

		# If this specific port is cloed,
		if [ $portStatus == "closed" ]; then
			continue;
		fi		

		# TCP services
		if [[ -z "$ip" ]] || [[ $service == *"HTTPAPI"* ]] || [[ $service == "tcpwrapped" ]]; then
			continue
		elif [[ $port == "21" ]]; then
			echo $ip >> ftp_hosts.txt
			ftpCount+=1
		elif [[ $port == "22" ]]; then
			echo $ip >> ssh_hosts.txt
			sshCount+=1
		elif [[ $port == "23" ]]; then
			echo $ip >> telnet_hosts.txt
			telnetCount+=1
		elif [[ $port == "25" ]]; then
			echo $ip >> smtp_hosts.txt
			smtpCount+=1
		elif [[ $port == "111" ]]; then
			echo $ip >> rpc_hosts.txt
			rpcCount+=1
		elif [[ $port == "389" ]]; then
			echo $ip >> ldap_hosts.txt
			ldapCount+=1
		elif [[ $port == "445" || $port == "139" ]]; then
			echo $ip >> smb_hosts.txt
			smbCount+=1
		elif [[ $port == "1433" ]]; then
			echo $ip >> mssql_hosts.txt
			mssqlCount+=1
		elif [[ $port == "2049" ]]; then
			echo $ip >> nfs_hosts.txt
			nfsCount+=1
		elif [[ $port == "3306" ]]; then
			echo $ip:$port >> sql_hosts.txt
			sqlCount+=1
		elif [[ $port == "3389" ]]; then
			echo $ip >> rdp_hosts.txt
			rdpCount+=1
		elif [[ $port == "80" || $port == "8080" ]]; then
			echo $ip:$port >> http_hosts.txt
			httpCount+=1
		elif [[ $port == "443" || $port == "8443" || $service == *"https"* || $service == *"ssl"* ]]; then
			echo $ip:$port >> https_hosts.txt
			httpsCount+=1
		elif [[ $service == *"http"* ]]; then
			echo $ip:$port >> http_hosts.txt
			httpCount+=1
		fi

		#UDP services
		if [ $port == '53' ]; then
			echo $ip >> dns_hosts.txt
			dnsCount+=1
		elif [ $port == '161' ]; then
			echo $ip >> snmp_hosts.txt
			snmpCount+=1
		elif [ $port == '504' ]; then
			echo $ip >> syslog_hosts.txt
			syslogCount+=1
		fi

	done
done< nmap_extractor_result


echo '=============' | tee -a nmap_extractor_result.txt
echo 'Stats' | tee -a nmap_extractor_result.txt
echo '=============' | tee -a nmap_extractor_result.txt
echo 'ftp hosts: '$ftpCount | tee -a nmap_extractor_result.txt
echo 'ssh hosts: '$sshCount | tee -a nmap_extractor_result.txt
echo 'telnet hosts: '$telnetCount | tee -a nmap_extractor_result.txt
echo 'smtp hosts: '$smtpCount | tee -a nmap_extractor_result.txt
echo 'rpc hosts: '$rpcCount | tee -a nmap_extractor_result.txt
echo 'ldap hosts: '$ldapCount | tee -a nmap_extractor_result.txt
echo 'smb hosts: '$smbCount | tee -a nmap_extractor_result.txt
echo 'mssql hosts: '$mssqlCount | tee -a nmap_extractor_result.txt
echo 'nfs hosts: '$nfsCount | tee -a nmap_extractor_result.txt
echo 'sql hosts: '$sqlCount | tee -a nmap_extractor_result.txt
echo 'rdp hosts: '$rdpCount | tee -a nmap_extractor_result.txt
echo 'http services: '$httpCount | tee -a nmap_extractor_result.txt
echo 'https services: '$httpsCount | tee -a nmap_extractor_result.txt
echo 
echo
echo 'UDP Services:'
echo 'dns services: '$dnsCount | tee -a nmap_extractor_result.txt
echo 'snmp services: '$snmpCount | tee -a nmap_extractor_result.txt
echo 'syslog services: '$syslogCount | tee -a nmap_extractor_result.txt


rm nmap_extractor_result
