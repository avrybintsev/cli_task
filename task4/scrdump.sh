source "./scrdump.config"

process () {
	name=$1
	interval=$2
	while [ true ]
	do
		filename=$STORAGE"/"$name"_"`date +%y%m%d_%H%M%S`".png"
		screencapture $filename
		sleep $interval
	done
}

for user in ${USERS[@]} 
do
	personal_interval_var="${user}_INTERVAL"
	personal_interval="${!personal_interval_var}"
	default_interval=$DUMP_INTERVAL
	interval=$default_interval
	if [[ $personal_interval != "" ]]
	then
		let interval=$personal_interval
	fi
	process $user $interval &
	echo "$!" >> scrdump.active
done