#!/bin/bash

for param in "$@"
do
	if [ "$param" == "--help" ]
	then
		echo "html'yzer of input" 
		echo "use input file as a parameter"
		exit
	fi
done

file=$1

echo "<html><body>"
sed -e 's/&/\&amp;/g' \
    -e 's/</\&lt;/g' \
    -e 's/>/\&gt;/g' \
    -e 's/\"/\&quot;/g' \
    -e '/^Part /!s/$/<br>/g' \
    -e 's/^Part .*$/<h1>&<\/h1>/g' $file
echo "</body></html>"
