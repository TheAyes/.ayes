#! /run/current-system/sw/bin/bash
set -e
pushd ~/.nixos

if git diff --quiet '*.nix' ./config; then
    echo "No changes detected, exiting."
    popd
    exit 0
fi

git diff -U0 '*.nix' ./config/

nixos-rebuild --use-remote-sudo test --flake ~/.nixos/

popd