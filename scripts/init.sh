#!/bin/bash

# This script sets up the necessary directory structure for the
# eclipse-mosquitto Docker container volume mounts.

# Exit immediately if a command exits with a non-zero status.
set -e

# Define the main directory name
MOSQUITTO_DIR="mosquitto"

echo "Creating base directory: $MOSQUITTO_DIR"
mkdir -p $MOSQUITTO_DIR

echo "Creating subdirectories for config, data, and log..."
mkdir -p "$MOSQUITTO_DIR/config"
mkdir -p "$MOSQUITTO_DIR/data"
mkdir -p "$MOSQUITTO_DIR/log"

# Check if mosquitto.conf exists before copying
if [ -f "mosquitto.conf" ]; then
    echo "Copying mosquitto.conf to $MOSQUITTO_DIR/config/"
    cp mosquitto.conf "$MOSQUITTO_DIR/config/"
else
    echo "Warning: mosquitto.conf not found in the current directory. A blank config directory has been created."
fi

echo ""
echo "Setup complete!"
echo "The directory structure '$MOSQUITTO_DIR' is ready for the Docker volume mounts."