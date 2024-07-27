#! /run/current-system/sw/bin/bash
pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

export pushd popd
export nixosConfigPath="$HOME/.nixos"
export update="nix flake update $nixosConfigPath"
export rebuild="nixos-rebuild --use-remote-sudo --flake $nixosConfigPath --option eval-cache=false"

export return=popd

set -e
pushd "$nixosConfigPath"