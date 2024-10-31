#! /run/current-system/sw/bin/bash

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

export -f pushd popd
export nixosConfigPath="$HOME/.nixos"
export update="nix flake update --flake $nixosConfigPath"
export rebuild="nixos-rebuild -v --use-remote-sudo --flake $nixosConfigPath"

export return=popd

set -e
pushd "$nixosConfigPath"