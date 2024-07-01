#! /run/current-system/sw/bin/bash
set -e
pushd ~/.nixos

# Early return if no changes were detected (thanks @singiamtel!)
#if git diff --quiet '*.nix' ./config; then
#    echo "No changes detected, exiting."
#    popd
#    exit 0
#fi


# Autoformat your nix files
#alejandra . &>/dev/null \
#  || ( alejandra . ; echo "formatting failed!" && exit 1)

# Shows your changes
git --no-pager diff -U0 '*.nix' '*.sh' '*.css' '*.scss' '*.js' '*.ts' '*.md' '*.json'

echo "NixOs Rebuilding..."

# Rebuild, output simplified errors, log tracebacks
nixos-rebuild --use-remote-sudo switch --flake ~/.nixos/ &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current)

# Commit all changes with the generation metadata, if not test mode
git commit -am "$current"

# Back to where you were
popd
