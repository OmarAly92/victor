#!/usr/bin/env bash

set -euo pipefail

REPO="OmarAly92/victor"
INSTALL_DIR="/usr/local/bin"
BINARY_NAME="victor"

if ! command -v gh &>/dev/null; then
  echo "GitHub CLI (gh) is required. Install it from: https://cli.github.com"
  exit 1
fi

if ! gh auth status &>/dev/null; then
  echo "Not logged in to GitHub. Run: gh auth login"
  exit 1
fi

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
gh release download latest \
  --repo "$REPO" \
  --pattern "agent-$PLATFORM.zip" \
  --dir "$TMP_DIR"

echo "Installing..."
unzip -q "$TMP_DIR/agent-$PLATFORM.zip" -d "$TMP_DIR"
chmod +x "$TMP_DIR/agent/victor"
sudo mv "$TMP_DIR/agent/victor" "$INSTALL_DIR/$BINARY_NAME"
rm -rf "$TMP_DIR"

echo "Done. Run: victor"
