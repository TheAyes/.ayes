#!/usr/bin/env bash
if ! command -v dotool > /dev/null 2>&1; then
	echo "dotool seems to be unavailable. Make sure to install it before using these scripts!"
fi

while true; do
	sleep 5
	echo "mousemove 20 0" | dotool
	sleep 1
	echo "mousemove 0 20" | dotool
	sleep 1
    echo "mousemove -20 0" | dotool
    sleep 1
    echo "mousemove 0 -20" | dotool
done
