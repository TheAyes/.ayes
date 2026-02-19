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
    echo "Remove it first if you want to import a new one."
    exit 1
fi

# Create directory
mkdir -p "$KEY_DIR"

# Prompt for key
echo "Paste your age secret key (starts with AGE-SECRET-KEY-):"
read -r SECRET_KEY

# Validate key format
if [[ ! "$SECRET_KEY" =~ ^AGE-SECRET-KEY-[A-Z0-9]+$ ]]; then
    echo "Invalid key format. Must start with AGE-SECRET-KEY-"
    exit 1
fi

# Write key
echo "$SECRET_KEY" > "$KEY_FILE"
chmod 600 "$KEY_FILE"

echo ""
echo "Key imported to $KEY_FILE"
echo ""
echo "Public key:"
grep -v '^#' "$KEY_FILE" | age-keygen -y
