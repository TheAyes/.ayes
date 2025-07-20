#! /run/current-system/sw/bin/bash
DIR=$(git rev-parse --show-toplevel)
MESSAGE=$("$DIR"/scripts/commit_message.sh)

if nixos-rebuild switch --sudo --flake "$DIR"; then
  git add .
  git commit -m "$MESSAGE"
fi