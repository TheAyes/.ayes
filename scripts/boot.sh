#! /run/current-system/sw/bin/bash
DIR=$(git rev-parse --show-toplevel)

nh os boot "$DIR" --ask --diff=auto
