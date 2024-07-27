#! /run/current-system/sw/bin/bash
. ./commands.sh

# Rebuild, output simplified errors, log tracebacks
$rebuild switch

# Commit all changes with the generation metadata
git commit -am "$(nixos-rebuild list-generations | grep current)"

$return
