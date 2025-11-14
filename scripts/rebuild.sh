#! /run/current-system/sw/bin/bash
DIR=$(git rev-parse --show-toplevel)
MESSAGE=$("$DIR"/scripts/commit_message.sh)

if [ -z "$1" ]; then
	echo "error: missing positional argument <COMMAND>"
	echo ""
	echo "Usage: rebuild.sh <COMMAND> [--upgrade]"

	exit 1
fi

if ! nh os "$1" "$DIR" --ask --diff=auto $2; then
	exit 2
fi

if [[ "${1,,}" != "test" && "${1,,}" != "build" ]]; then
    git add .
    git commit -m "$MESSAGE"
fi
