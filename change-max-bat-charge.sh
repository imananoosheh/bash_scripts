#!/usr/bin/env bash

bold=$(tput bold)
normal=$(tput sgr0)
log_file=<your-address-goes-here>/change-max-bat-charge-logs.txt

echo "${bold}Current ${normal}battery max charge threshold: ${bold}$(cat /sys/class/power_supply/BAT1/charge_control_end_threshold)%${normal}"

if [ $# -eq 0 ]
then
	#The default Battery Max Threshold is 80%, meaning battery will be charged upto 79%
	echo 80 | sudo tee /sys/class/power_supply/BAT1/charge_control_end_threshold
	echo "$(date)\tchanged to\t$(cat /sys/class/power_supply/BAT1/charge_control_end_threshold)" >> $log_file
else
	if [ $1 -lt 100 ]
	then
		echo $1 | sudo tee /sys/class/power_supply/BAT1/charge_control_end_threshold
		echo "$(date)\tcharge_control_end_threshold value changed to\t$(cat /sys/class/power_supply/BAT1/charge_control_end_threshold)" >> $log_file
	else
		echo "${normal}Inputed argument for max battery charged threshold is bigger than 99% which is not valid.\n ${bold}Job is not done.${normal}"
		echo "${normal}$(date)\tInputed argument for max battery charged threshold is bigger than 99% which is not valid. ${bold}Job is not done.${normal}" >> $log_file
	fi
fi
echo "Battery max charge threshold ${bold}CHANGED TO: $(cat /sys/class/power_supply/BAT1/charge_control_end_threshold)%"
