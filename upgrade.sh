#! /run/current-system/sw/bin/bash
. ./commands.sh

$update
$rebuild build

diff=$(nix store diff-closures /run/current-system ./result --no-warn-dirty)
echo "$diff"

REPLY="Y"
if [[ -z "$diff" ]]; then
    echo "No updates found. Exiting..."
else
	read -p "Found $(echo "$diff" | wc -l) updates. Proceed with update? (Y|n) " -n 1 -r
	REPLY=${REPLY:-"Y"}

	rm -rf ./result
	if [[ ! $REPLY =~ ^[Yy]$ ]]; then
		[[ "$0" = "${BASH_SOURCE[*]}" ]] && exit 1 || return 1
	fi
	./rebuild.sh
fi

$return