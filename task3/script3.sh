#!/bin/bash

for param in "$@"
do
	if [ "$param" == '--help' ]
	then
		echo "log analyzer"
		echo "use input file as first parameter and specific date as second one"
		exit
	fi
done

file=$1
date=$2

grep "$date 12:.*/resume.* 200 .*" $file | sort -n -k 8 | awk '
function Q(array, len, q) {
	return array[int(q*len+0.5)];
}
BEGIN {
	count = 0;
	sum = 0.0;
}
{
	piece = $8;
	sub( "[.]", ",", piece );
	indms = index(piece, "ms") - 1;
	time = substr(piece, 0, indms);
	
	count += 1
	array[count-1] = time
	sum += time
}
END {
	print "Successful requests from 12:00:00 till 13:00:00 on '"$date"' for resume";
	print "Total requests: " count;
	print sprintf("Total time: %6.2f", sum);
	print sprintf("Quantile 0.5 (Median): %6.2f", Q(array, count, 0.5));
	print sprintf("Quantile 0.95: %6.2f", Q(array, count, 0.95));
	print sprintf("Quantile 0.99: %6.2f", Q(array, count, 0.99));
}
'

grep "$date .*/resume?id=43.*" $file | sort -n -k 8 | awk '
function Q(array, len, q) {
	return array[int(q*len+0.5)];
}
BEGIN {
	count = 0;
	sum = 0.0;
}
{
	piece = $8;
	sub( "[.]", ",", piece );
	indms = index(piece, "ms") - 1;
	time = substr(piece, 0, indms);
	
	count += 1
	array[count-1] = time
	sum += time
}
END {
	print "Requests on '"$date"' for resume?id=43";
	print "Total requests: " count;
	print sprintf("Total time: %6.2f", sum);
	print sprintf("Quantile 0.5 (Median): %6.2f", Q(array, count, 0.5));
	print sprintf("Average: %6.2f", sum/count);
}
'

grep "$date .*" $file | sort -n -k 8 | awk '
{
	datetime = sprintf("%s %s", $1, $2);
	sub( "[,]", ".", datetime );

	request = $6;
	if (request ~ "resume") {
		field = "resume";
	} else if (request ~ "vacancy") {
		field = "vacancy";
	} else if (request ~ "user") {
		field = "user";
	}

	piece = $8;
	indms = index(piece, "ms") - 1;
	requesttime = substr(piece, 0, indms);
	
	print datetime, sprintf("=%s", field), requesttime;
}
' | sort -n > plot_data.txt
tplot -if plot_data.txt -of png -or 1920x1080 -o "quantile.png" -dk 'quantile 250 0.95'
rm plot_data.txt