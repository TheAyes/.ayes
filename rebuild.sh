#! /run/current-system/sw/bin/bash
set -e
pushd ~/.nixos

# Early return if no changes were detected (thanks @singiamtel!)
if git diff --quiet '*.nix'; then
    echo "No changes detected, exiting."
    popd
    exit 0
fi

# Autoformat your nix files
#alejandra . &>/dev/null \
#  || ( alejandra . ; echo "formatting failed!" && exit 1)

# Shows your changes
git diff -U0 '*.nix'

echo "NixOs Rebuilding..."

# Rebuild, output simplified errors, log tracebacks
sudo nixos-rebuild switch &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current)

# Commit all changes with the generation metadata
git commit -am "$current"

# Back to where you were
popd