#! /run/current-system/sw/bin/bash
set -e
pushd ~/.nixos

if git diff --quiet '*.nix' ./config; then
    echo "No changes detected, exiting."
    popd
    exit 0
fi

git diff -U0 '*.nix' ./config/

sudo nixos-rebuild test --flake ~/.nixos/

popd