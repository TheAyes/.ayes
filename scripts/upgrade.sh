#! /run/current-system/sw/bin/bash
DIR=$(git rev-parse --show-toplevel)

nix flake update --flake $DIR
nixos-rebuild build --use-remote-sudo --flake $DIR

diff=$(nix store diff-closures /run/current-system ./result --no-warn-dirty)
echo "$diff"

REPLY="Y"
if [[ -z "$diff" ]]; then
    echo "No updates found. Exiting..."
else
	read -p "Found $(echo "$diff" | wc -l) updates. Proceed with update? (Y|n) " -n 1 -r
	REPLY=${REPLY:-"Y"}

	if [[ ! $REPLY =~ ^[Yy]$ ]]; then
		[[ "$0" = "${BASH_SOURCE[*]}" ]] && exit 1 || return 1
	fi
	sudo ./result/activate

	rm -rf ./result
fi

$return