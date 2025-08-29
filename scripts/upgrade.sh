#! /run/current-system/sw/bin/bash
DIR=$(git rev-parse --show-toplevel)

nix flake update --flake "$DIR"
nixos-rebuild build --sudo --flake "$DIR"

DIFF=$(nix store diff-closures /run/current-system ./result --no-warn-dirty)
if [[ -z "$DIFF" ]]; then
	echo "No updates found. Exiting..."
	exit 0
else
	echo "$DIFF"
fi

read -p "Found $(echo "$DIFF" | grep -c '^') updates. Proceed with update? (Y|n) " -n 1 -r USER_INPUT
REPLY=${USER_INPUT:-"Y"}
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	exit 1
fi

REBUILD_SCRIPT="$DIR/scripts/rebuild.sh"
if [[ ! -x "$REBUILD_SCRIPT" ]]; then
	echo "Error: rebuild script not found or not executable"
	exit 1
else
	"$REBUILD_SCRIPT"
fi

RESULT_DIR="$DIR"/result
if [[ -d "$RESULT_DIR" ]]; then
	rm -rf "$RESULT_DIR"
fi
