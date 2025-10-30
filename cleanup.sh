#!/bin/bash
#
# A script to remove the entire mosquitto directory.
# Must be run with sudo as the directory is owned by user 1883.
#

set -e # Exit immediately if any command fails

# --- Configuration ---
BASE_DIR="./mosquitto"

# --- Main ---

# Check if we are running as root (with sudo)
if [ "$EUID" -ne 0 ]; then
  echo "Error: This script must be run with sudo." >&2
  echo "  Usage: sudo $0" >&2
  exit 1
fi

# Check if directory exists
if [ ! -d "$BASE_DIR" ]; then
  echo "Cleanup success (Directory '$BASE_DIR' not found)."
  exit 0
fi

# Remove the directory
# -r (recursive) and -f (force)
rm -rf "$BASE_DIR"

echo "Cleanup success."