#! /run/current-system/sw/bin/bash
DIR=$(git rev-parse --show-toplevel)

nh os switch "$DIR" --ask --diff=auto --update


