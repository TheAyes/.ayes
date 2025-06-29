#! /run/current-system/sw/bin/bash
DIR=$(git rev-parse --show-toplevel)

nixos-rebuild switch --sudo --flake "$DIR"

git add .
git commit -m "$("$DIR"/scripts/commit_message.sh)"
