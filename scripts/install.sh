#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT_DIR/scripts/OutlookToTodoist.applescript"

# Default install location (Script menu)
TARGET_DIR="$HOME/Library/Scripts"

# Use --outlook or OUTLOOK_MENU=1 to install into Outlook-specific Scripts folder
if [[ "${1:-}" == "--outlook" || "${OUTLOOK_MENU:-}" == "1" ]]; then
  TARGET_DIR="$HOME/Library/Scripts/Applications/Microsoft Outlook"
fi

mkdir -p "$TARGET_DIR"
cp "$SRC" "$TARGET_DIR/OutlookToTodoist.applescript"

echo "Installed to: $TARGET_DIR/OutlookToTodoist.applescript"
