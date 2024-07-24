#! /run/current-system/sw/bin/bash
. ./commands.sh

$update
$rebuild build

echo ''
nix store diff-closures /run/current-system ./result | awk '/[0-9] →|→ [0-9]/ && !/nixos/' || echo

read -p $'\nProceed with update? (Y|n) ' answer

case ${answer:0:1} in
	n|N )

	;;
	* )
		$rebuild switch
	;;
esac

$return