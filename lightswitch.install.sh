#!/bin/bash

# Install Lightswitch

# Check for sudo privileges
if [ "$(id -u)" -ne 0 ]; then
  echo "This script requires root privileges."
  exit 1
fi

# Set installation directories
INSTALL_DIR="/usr/local/bin"
MAN_DIR="/usr/share/man/man1"

# Install Lightswitch script
echo "Installing Lightswitch to $INSTALL_DIR..."
cp lightswitch "$INSTALL_DIR/lightswitch"
chmod +x "$INSTALL_DIR/lightswitch"

# Install Man Page
echo "Installing man page..."
cp lightswitch.1 "$MAN_DIR/lightswitch.1"

# Update man database
echo "Updating man database..."
mandb

echo "Lightswitch installation completed!"

