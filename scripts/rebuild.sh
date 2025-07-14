#! /run/current-system/sw/bin/bash
DIR=$(git rev-parse --show-toplevel)
MESSAGE=$("$DIR"/scripts/commit_message.sh)

nixos-rebuild switch --sudo --flake "$DIR"

git add .
git commit -m "$MESSAGE"
