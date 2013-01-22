#!/bin/bash

for param in "$@"
do
	if [ "$param" == "--help" ]
	then
		echo "outputs enumerated list of *.txt files in current directory" 
		echo "use line number to see the head of appropriate file"
		echo "use 'q' to exit"
	else
		echo "Unknown parameter: $param"
	fi
done

while [ "$command" != "q" ]
do
	echo "List of text files in current dir:"
	
	array=($(find . -name "*.txt" -d 1 -print))
	size=${#array[@]}
	
	echo ${array[@]} | tr ' ' '\n' | nl
	
	echo "Enter 'q' to quit"
	echo "Enter number of file to show it"
	
	read command
	
	if [[ "$command" =~ ^[0-9]+$ ]]
	then
   		if [ "$command" -gt 0 ] && [ "$command" -le $size ]
		then
			let index=$command-1
			head -10 ${array[$index]}
		else
			echo "Bad number"
		fi
	else
		if [ "$command" != "q" ]
		then 
			echo "Not a number"
		fi
	fi
done