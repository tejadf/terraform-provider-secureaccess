#!/usr/bin/env bash
# Builds the provider from this repo and writes a Terraform CLI config (dev.tfrc)
# that points Terraform at the local build instead of the registry.
#
# Usage (from the repo root):
#   ./local-dev/setup.sh
#   export TF_CLI_CONFIG_FILE="$PWD/local-dev/tf/dev.tfrc"
set -euo pipefail

LOCAL_DEV="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$LOCAL_DEV")"
BIN_DIR="$LOCAL_DEV/bin"

echo "Building provider into $BIN_DIR"
mkdir -p "$BIN_DIR"
go build -C "$REPO_ROOT" -o "$BIN_DIR/terraform-provider-secureaccess" .

echo "Building fake API into $BIN_DIR"
go build -C "$LOCAL_DEV/mock-api" -o "$BIN_DIR/mock-api" .

# dev_overrides needs an absolute path, so this file is generated per machine
cat > "$LOCAL_DEV/tf/dev.tfrc" <<EOF
provider_installation {
  dev_overrides {
    "netascode/secureaccess" = "$BIN_DIR"
  }
  direct {}
}
EOF

echo
echo "Done. Next:"
echo "  export TF_CLI_CONFIG_FILE=\"$LOCAL_DEV/tf/dev.tfrc\""
echo "  cd \"$LOCAL_DEV/tf\" && terraform plan"
