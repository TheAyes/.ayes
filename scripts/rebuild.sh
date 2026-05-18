#! /run/current-system/sw/bin/bash
DIR=$(git rev-parse --show-toplevel)
MESSAGE=$("$DIR"/scripts/commit_message.sh)

if [ -z "$1" ]; then
	echo "error: missing positional argument <COMMAND>"
	echo ""
	echo "Usage: rebuild.sh <COMMAND> [OPTIONS...]"

	exit 1
fi

COMMAND="$1"
shift

HEADLESS=0
ARGS=()
for arg in "$@"; do
	if [ "$arg" = "--headless" ]; then
		HEADLESS=1
	else
		ARGS+=("$arg")
	fi
done

ASK_FLAG=""
[ -t 0 ] && [ "$HEADLESS" -eq 0 ] && ASK_FLAG="--ask"

if ! nh os "$COMMAND" "$DIR" $ASK_FLAG --diff=auto "${ARGS[@]}"; then
	exit 2
fi

if [[ "${COMMAND,,}" != "test" && "${COMMAND,,}" != "build" && "$HOSTNAME" != "janus" ]]; then
	git add .
	git commit -m "$MESSAGE"
fi
