#! /run/current-system/sw/bin/bash
DIR=$(git rev-parse --show-toplevel)

if [ -z "$1" ]; then
	echo "error: missing positional argument <COMMAND>"
	echo ""
	echo "Usage: rebuild.sh <COMMAND> [OPTIONS...]"

	exit 1
fi

COMMAND="$1"
shift

HEADLESS=0
TARGET_HOST=""
ARGS=()
for arg in "$@"; do
	case "$arg" in
		--headless)
			HEADLESS=1
			;;
		--target-host=*)
			TARGET_HOST="${arg#*=}"
			ARGS+=("$arg")
			;;
		*)
			ARGS+=("$arg")
			;;
	esac
done

ASK_FLAG=""
[ -t 0 ] && [ "$HEADLESS" -eq 0 ] && ASK_FLAG="--ask"

if ! nh os "$COMMAND" "$DIR" $ASK_FLAG --diff=auto "${ARGS[@]}"; then
	exit 2
fi

if [[ "${COMMAND,,}" != "test" && "${COMMAND,,}" != "build" && "$HOSTNAME" != "janus" ]]; then
	MESSAGE=$("$DIR"/scripts/commit_message.sh "$TARGET_HOST")
	git add .
	git commit -m "$MESSAGE"
fi
