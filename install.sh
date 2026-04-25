#!/usr/bin/env bash

set -euo pipefail

REPO="OmarAly92/victor"
INSTALL_DIR="/usr/local/bin"
BINARY_NAME="victor"

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
case "$OS" in
  linux)  PLATFORM="linux" ;;
  darwin) PLATFORM="mac" ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

echo "Downloading victor ($PLATFORM)..."
TMP_DIR=$(mktemp -d)
curl -fsSL \
  "https://github.com/$REPO/releases/latest/download/agent-$PLATFORM.zip" \
  -o "$TMP_DIR/agent.zip"

echo "Installing..."
unzip -q "$TMP_DIR/agent.zip" -d "$TMP_DIR"
chmod +x "$TMP_DIR/agent/victor"
sudo mv "$TMP_DIR/agent/victor" "$INSTALL_DIR/$BINARY_NAME"
rm -rf "$TMP_DIR"

echo "Done. Run: victor"
