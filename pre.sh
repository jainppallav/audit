#!/bin/bash
username=root
#read -p "Enter file for IP(s): " hosts
read -p "Enter range for IP(s:) [Ex:- 172.10.20] " nwt
read -p "Enter host(s) range [Ex:- 1 100]" ht
seq -f "`echo $nwt`.%g" `echo $ht` > ip.txt
#awk '/^[0-9]/{print $1}' $hosts > ip.txt
for host in `cat ip.txt`; 
do 
scp check $username@$host:
sleep 3
echo "now ssh"
ssh -o StrictHostKeyChecking=no $username@$host './check;exit'
scp "$host:~/*.spec" .
ssh -o StrictHostKeyChecking=no $username@$host "rm -rfv check;rm -rfv *.spec;exit"
echo "ssh done"
sleep 2
done
sleep 5
perl -F'\012' -00ane 'BEGIN {$, = ","; $\ = "\n"; print("Hostname,Make_and_Model,System_Serial_Number,OS,Total_RAM,Type,CPU_family_and_Arch.,Hard_disk(s),Total_Storage_Size,RAID,Graphics_Card(s),CD/DVD_slots")} my @f; foreach(@F) {s/.*?: +//; push(@f, $_)} print(@f)' `ls -tr | grep .spec` > final.csv
