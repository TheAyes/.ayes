#!/run/current-system/sw/bin/bash
nixos-rebuild list-generations --json | jq -r '.[0] | "[\(.generation)] Version \(.nixosVersion) - \(.kernelVersion)\n\nBuilt: \(.date)"'