#!/bin/bash

# This script securely creates or updates a user in the Mosquitto password file
# and resets the necessary directory permissions.

# --- Configuration ---
MOSQUITTO_DIR="$(pwd)/mosquitto"
CONFIG_PATH="$MOSQUITTO_DIR/config"
PASSWORD_FILE="$CONFIG_PATH/password.txt"
MOSQUITTO_UID=1883
# ---------------------

# Ensure the script is run from the correct directory
if [ ! -d "$CONFIG_PATH" ]; then
    echo "Error: Directory '$CONFIG_PATH' not found."
    echo "Please make sure you are in the same directory as your docker-compose.yml file and the 'mosquitto' directory exists."
    exit 1
fi

# Get username from the first argument, or prompt if not provided
if [ -z "$1" ]; then
    read -p "Enter username : " username
else
    username=$1
fi

if [ -z "$username" ]; then
    echo "Error: Username cannot be empty."
    exit 1
fi

# Get password securely without echoing to the terminal
read -s -p "Enter password : " password
echo

if [ -z "$password" ]; then
    echo "Error: Password cannot be empty."
    exit 1
fi

# Use -c flag (create) only if the password file doesn't exist
if [ -f "$PASSWORD_FILE" ]; then
    echo "Updating existing password file..."
    docker run --rm \
      -v "$CONFIG_PATH:/mosquitto/config" \
      eclipse-mosquitto:latest sh -c "mosquitto_passwd -b /mosquitto/config/password.txt '$username' '$password'"
else
    echo "Creating new password file..."
    docker run --rm \
      -v "$CONFIG_PATH:/mosquitto/config" \
      eclipse-mosquitto:latest sh -c "mosquitto_passwd -c -b /mosquitto/config/password.txt '$username' '$password'"
fi

# Fix permissions on the host, as the docker command above will create files as root
echo "Resetting permissions for the ./mosquitto directory..."
if sudo chown -R $MOSQUITTO_UID:$MOSQUITTO_UID "$MOSQUITTO_DIR"; then
    echo "Permissions successfully set for user $MOSQUITTO_UID."
    echo 
    echo "User '$username' is ready to use."
else
    echo "Error: Failed to set permissions. Please run the following command manually:"
    echo "sudo chown -R $MOSQUITTO_UID:$MOSQUITTO_UID ./mosquitto"
fi