#!/usr/bin/bash

#setting varible for the file including temperature  value of the CPU 
TEMP_FILE=/sys/class/thermal/thermal_zone0/temp

counter=10
if [ $# -gt 0 ]
then
	# checking if the input is number using regex
	re='^[0-9]+$'
	if ! [[ $1 =~ $re ]]
	then
   		echo "error: Input is not a number";
   		exit 1;
	else
		counter=$(($1*2))
	fi
fi

#defined a function which retrived the current temp value and devides it into a Celsius value
getCpuTemp() {
	local CURRENT_TEMP_VALUE=$(cat $TEMP_FILE)
	#temperature in Centigrade
	echo $((CURRENT_TEMP_VALUE/1000))
}

#defining an array to calculate an average
Temp_List=()

for ((i = $counter ; i >= 0 ; i--));
do
	echo -en "CPU Temperature: $(getCpuTemp)\xe2\x84\x83 \nSelf-termination in $((i/2))s  ";
	Temp_List+=($(getCpuTemp))
	sleep 0.5
	#going two lines up and printing a newline each time; the number 2 before A represent number of line going backwards
	printf "\033[2A\n"
done

printf "\n\n"

average_temp=0
declare -i counter_temp=0
for temp in "${Temp_List[@]}"
do

	average_temp=$(( average_temp + temp ))
	counter_temp+=1
done

printf "\033[2AAverage Temperature:  $(echo "scale=2; $average_temp/$counter_temp" | bc)\xe2\x84\x83\n"

