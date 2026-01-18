#!/usr/bin/env bash
set -euo pipefail

# Installer for nginx site: copies bundled config to /etc/nginx/sites-available
# and enables it. Requires sudo.

CONF_SRC="$(cd "$(dirname "$0")" && pwd)/nginx/mylab-ui.conf"
TARGET_NAME="mylab-ui"
SITES_AVAIL="/etc/nginx/sites-available"
SITES_ENABLED="/etc/nginx/sites-enabled"

if [ "$(id -u)" -ne 0 ]; then
  echo "This script needs sudo. Re-run with sudo."
  exit 2
fi

if [ ! -f "$CONF_SRC" ]; then
  echo "Source config not found: $CONF_SRC"
  exit 3
fi

mkdir -p "$SITES_AVAIL"
mkdir -p "$SITES_ENABLED"

cp -f "$CONF_SRC" "$SITES_AVAIL/$TARGET_NAME"
ln -sf "$SITES_AVAIL/$TARGET_NAME" "$SITES_ENABLED/$TARGET_NAME"

echo "Testing nginx config..."
nginx -t

echo "Reloading nginx..."
systemctl reload nginx

echo "Installed $TARGET_NAME site and reloaded nginx. Listening on port 38080."
