#!/bin/sh
set -e

echo "==================================="
echo "MQTT Mosquitto Container Starting"
echo "==================================="

# Check if username and password are provided
if [ -z "$MQTT_USERNAME" ] || [ -z "$MQTT_PASSWORD" ]; then
  echo "ERROR: MQTT_USERNAME and MQTT_PASSWORD must be set!"
  echo "Please set these environment variables."
  exit 1
fi

echo "Setting up MQTT user: $MQTT_USERNAME"

# Create password file
mosquitto_passwd -c -b /mosquitto/config/password.txt "$MQTT_USERNAME" "$MQTT_PASSWORD"

if [ $? -eq 0 ]; then
  echo "✓ Password file created successfully"
else
  echo "✗ Failed to create password file"
  exit 1
fi

# Fix permissions
echo "Setting permissions..."
chown -R mosquitto:mosquitto /mosquitto
chmod -R 755 /mosquitto

echo "✓ Permissions set"
echo "==================================="
echo "Starting Mosquitto MQTT Broker..."
echo "  MQTT Port: 1883"
echo "  WebSocket Port: 9001"
echo "  User: $MQTT_USERNAME"
echo "==================================="

# Start mosquitto
exec /usr/sbin/mosquitto -c /mosquitto/config/mosquitto.conf

