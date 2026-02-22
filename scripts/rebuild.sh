#! /run/current-system/sw/bin/bash
DIR=$(git rev-parse --show-toplevel)
MESSAGE=$("$DIR"/scripts/commit_message.sh)

if [ -z "$1" ]; then
	echo "error: missing positional argument <COMMAND>"
	echo ""
	echo "Usage: rebuild.sh <COMMAND> [OPTIONS...]"

	exit 1
fi

ASK_FLAG=""
[ -t 0 ] && ASK_FLAG="--ask"

if ! nh os "$1" "$DIR" $ASK_FLAG --diff=auto "${@:2}"; then
	exit 2
fi

if [[ "${1,,}" != "test" && "${1,,}" != "build" && "$HOSTNAME" != "janus" ]]; then
	git add .
	git commit -m "$MESSAGE"
fi
