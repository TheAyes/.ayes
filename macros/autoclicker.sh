#!/usr/bin/env bash
if ! command -v dotool > /dev/null 2>&1; then
	echo "dotool seems to be unavailable. Make sure to install it before using these scripts!"
fi

dotoold &



for (( i = 0; i < 17; i++ )); do
	sleep 5

	echo "buttondown left" | dotoolc
	for (( j = 0; j < 11; j++ )); do
		sleep 1
	done
	echo "buttonup left" | dotoolc

	sleep 8
done


