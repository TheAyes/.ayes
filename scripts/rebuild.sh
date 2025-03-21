#! /run/current-system/sw/bin/bash
DIR=$(git rev-parse --show-toplevel)

nixos-rebuild switch --use-remote-sudo --flake $DIR

$return