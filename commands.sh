#! /run/current-system/sw/bin/bash
export nixosConfigPath="$HOME/.nixos"
export update="nix flake update $nixosConfigPath"
export rebuild="nixos-rebuild --use-remote-sudo --flake $nixosConfigPath --option eval-cache false"

export return="popd"

set -e
pushd "$nixosConfigPath"