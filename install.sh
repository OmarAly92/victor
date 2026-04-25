#!/usr/bin/env bash

set -euo pipefail

REPO="OmarAly92/victor"
INSTALL_DIR="/usr/local/share/victor"
BIN_LINK="/usr/local/bin/victor"

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

BUNDLE_DIR=$(find "$TMP_DIR" -type d -name "bundle" | head -1)
if [[ -z "$BUNDLE_DIR" ]]; then
  echo "Could not find bundle in zip"
  exit 1
fi

BINARY=$(find "$BUNDLE_DIR" -type f -name "victor" -o -name "telegram" | head -1)
if [[ -z "$BINARY" ]]; then
  echo "Could not find binary in bundle"
  exit 1
fi

if [[ "$(basename "$BINARY")" == "telegram" ]]; then
  mv "$BINARY" "$(dirname "$BINARY")/victor"
fi

sudo rm -rf "$INSTALL_DIR"
sudo mkdir -p "$(dirname "$INSTALL_DIR")"
sudo mv "$BUNDLE_DIR" "$INSTALL_DIR"
sudo chmod +x "$INSTALL_DIR/bin/victor"
sudo ln -sf "$INSTALL_DIR/bin/victor" "$BIN_LINK"

rm -rf "$TMP_DIR"

echo "Done. Run: victor"
