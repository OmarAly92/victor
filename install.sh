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

echo "Contents:"
find "$TMP_DIR" -type f

BINARY=$(find "$TMP_DIR" -type f -executable | head -1)
if [[ -z "$BINARY" ]]; then
  BINARY=$(find "$TMP_DIR" -type f | grep -v '\.zip$' | head -1)
fi

if [[ -z "$BINARY" ]]; then
  echo "Could not find binary in zip"
  exit 1
fi

chmod +x "$BINARY"
sudo mv "$BINARY" "$INSTALL_DIR/$BINARY_NAME"
rm -rf "$TMP_DIR"

echo "Done. Run: victor"
