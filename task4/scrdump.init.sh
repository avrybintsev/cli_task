do_start()
{
	./scrdump.sh
}

do_stop()
{
	kill `cat scrdump.active`
	rm scrdump.active
}

case "$1" in
	start) do_start
	;;
	
	stop) do_stop
	;;
esac