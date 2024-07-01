#! /run/current-system/sw/bin/bash
set -e
pushd ~/.nixos

sudo nix flake update
sudo nixos-rebuild switch --upgrade

popd
