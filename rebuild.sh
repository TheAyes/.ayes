#! /run/current-system/sw/bin/bash
. ./commands.sh

# Rebuild, output simplified errors, log tracebacks
$rebuild "switch"

echo "rebuild completed! Proceeding with git operations..."

# Commit all changes with the generation metadata
git add .
git commit -am "$(nixos-rebuild list-generations | grep current)"

$return
