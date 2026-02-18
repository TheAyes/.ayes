#!/usr/bin/env nix-shell
#!nix-shell -i bash -p age
set -euo pipefail

KEY_DIR="/var/lib/sops-nix"
KEY_FILE="$KEY_DIR/key.txt"

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root (use sudo)"
    exit 1
fi

# Check if key already exists
if [[ -f "$KEY_FILE" ]]; then
    echo "Key already exists at $KEY_FILE"
    echo ""
    echo "Public key:"
    grep -v '^#' "$KEY_FILE" | age-keygen -y
    exit 0
fi

# Create directory
mkdir -p "$KEY_DIR"

# Generate key
age-keygen -o "$KEY_FILE"
chmod 600 "$KEY_FILE"

echo ""
echo "Key generated at $KEY_FILE"
echo ""
echo "Add this public key to .sops.yaml:"
grep -v '^#' "$KEY_FILE" | age-keygen -y
echo ""
echo "Then run: sops updatekeys secrets/<host>.yaml"
