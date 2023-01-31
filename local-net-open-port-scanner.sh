#!/usr/bin/bash

#setting non-specific named variables
let val1=$RANDOM*$RANDOM
OCTETSTXTFILE=$val1
let val2=$RANDOM*$RANDOM
FOUNDIPSTXTFILE=$val2
let val3=$RANDOM*$RANDOM
SORTEDFOUNDIPSTXTFILE=$val3

#collating 3 first octets of broadcasting ips using ip commnad
ip address show | grep "inet " |grep brd | cut -d " " -f 6 | cut -d "/" -f 1 | cut -d "." -f 1,2,3 | uniq > $val1.txt

# setting veriable for found octets
OCTETS=$(cat $val1.txt)

#creating new txt file 
echo "" > $val2.txt

#looping through all possible ports to check for ping response
for ip in {1..254}
do
	for octet in $OCTETS
	do
		ping -c 1 $octet.$ip | grep "bytes from" | cut -d " " -f 4 | cut -d ":" -f 1 >> $val2.txt &
	done
done

cat $val2.txt | sort > $val3.txt

#cleaning up temp files (phase 1/2)
rm $val1.txt
rm $val2.txt

#printing found and sorted ips
echo "Here are found IPs connected to local network:"
echo $(cat $val3.txt)

#running nmap port scan
nmap -sS -iL $val3.txt

#cleaning up temp files (phase 2/2)
rm  $val3.txt

exit
