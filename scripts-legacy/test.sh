#! /run/current-system/sw/bin/bash
DIR=$(git rev-parse --show-toplevel)

nh os test "$DIR" --ask --diff=auto
