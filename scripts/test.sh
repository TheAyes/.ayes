#! /run/current-system/sw/bin/bash
DIR=$(git rev-parse --show-toplevel)

nixos-rebuild test --use-remote-sudo --flake "$DIR"
