#! /usr/bin/env ash

# Credits: Uri Savelchev

# Exit if uninitialized variable used, or any statement returns a non-true return value
set -eu

# Show usage message
helpme(){
    cat <<EOF
daemonize.sh start, run and proxy daemon's signals in the foreground as long as it's active.
Used with supervisor

Usage: $(basename $0) <pidfile> <command...>
EOF
}

# Check if arguments are missing
[ $# -lt 2 ] && helpme

# Get arguments
pidfile="$1"
shift
command=$@

# Go foreground, proxy signals
kill_ps(){
    kill $(cat $pidfile)
    exit 0
}

trap "kill_ps" SIGINT SIGTERM

# Launch daemon
$command
sleep 2

# Loop while the pidfile and the process exist
while [ -f $pidfile ] && kill -0 $(cat $pidfile) ; do
    sleep 0.5
done
exit 1000
