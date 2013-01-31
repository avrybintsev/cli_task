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

enumLines()
{
  index=1
  while read line
  do 
     echo "	$index: $line"
     let index=$index+1
  done
}

getByNum()
{
  flag=0
  required=$1
  index=1
  while read line
  do
     if [ $index == $required ]
     then
        flag=1
        filename=$line
        head -10 "$filename"
     fi
     let index=$index+1 
  done
  if [ $flag == 0 ]
  then
     echo "Bad number"
  fi
}

while [ "$command" != "q" ]
do
	echo "List of text files in current dir:"
	
       ls | grep ".txt$" | enumLines

	echo "Enter 'q' to quit"
	echo "Enter number of file to show it"
	
	read command
	
	if [[ "$command" =~ ^[0-9]+$ ]]
	then
   		ls | grep ".txt$" | getByNum $command
	else
		if [ "$command" != "q" ]
		then 
			echo "Not a number"
		fi
	fi
done