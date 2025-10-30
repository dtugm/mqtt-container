#!/bin/bash

# This script resets the Mosquitto configuration by deleting the password file
# and restoring ownership of the mosquitto directory to the current user.

# --- Configuration ---
MOSQUITTO_DIR="$(pwd)/mosquitto"
PASSWORD_FILE="$MOSQUITTO_DIR/config/password.txt"
# ---------------------

echo "This script will reset your Mosquitto setup."

# Check if the password file exists and delete it
if [ -f "$PASSWORD_FILE" ]; then
    echo "Deleting password file: $PASSWORD_FILE"
    if rm "$PASSWORD_FILE"; then
        echo "Password file deleted successfully."
    else
        echo "Error: Failed to delete the password file. You may need to use sudo."
        exit 1
    fi
else
    echo "Password file not found, skipping deletion."
fi

# Reset ownership of the mosquitto directory to the current user
CURRENT_USER=$(whoami)
echo "Resetting ownership of '$MOSQUITTO_DIR' to user '$CURRENT_USER'..."

if sudo chown -R $CURRENT_USER:$CURRENT_USER "$MOSQUITTO_DIR"; then
    echo "Directory ownership successfully reset."
else
    echo "Error: Failed to reset ownership. Please run the following command manually:"
    echo "sudo chown -R $CURRENT_USER:$CURRENT_USER ./mosquitto"
    exit 1
fi

echo ""
echo "Reset complete. You can now run './create_mqtt_creds.sh' to create a new user."