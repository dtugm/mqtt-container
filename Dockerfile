FROM eclipse-mosquitto:latest

# Set environment variables for username and password
ENV MQTT_USERNAME=""
ENV MQTT_PASSWORD=""

# Switch to root to perform setup operations
USER root

# Create necessary directories
RUN mkdir -p /mosquitto/config \
    && mkdir -p /mosquitto/data \
    && mkdir -p /mosquitto/log

# Copy the mosquitto configuration file
COPY mosquitto.conf /mosquitto/config/mosquitto.conf

# Create an entrypoint script that will set up the password file
RUN echo '#!/bin/sh' > /entrypoint.sh && \
    echo 'set -e' >> /entrypoint.sh && \
    echo '' >> /entrypoint.sh && \
    echo '# Check if username and password are provided' >> /entrypoint.sh && \
    echo 'if [ -n "$MQTT_USERNAME" ] && [ -n "$MQTT_PASSWORD" ]; then' >> /entrypoint.sh && \
    echo '  echo "Setting up MQTT user: $MQTT_USERNAME"' >> /entrypoint.sh && \
    echo '  mosquitto_passwd -c -b /mosquitto/config/password.txt "$MQTT_USERNAME" "$MQTT_PASSWORD"' >> /entrypoint.sh && \
    echo 'else' >> /entrypoint.sh && \
    echo '  echo "Warning: MQTT_USERNAME and MQTT_PASSWORD not set. Authentication will fail."' >> /entrypoint.sh && \
    echo '  echo "Please set MQTT_USERNAME and MQTT_PASSWORD environment variables."' >> /entrypoint.sh && \
    echo '  exit 1' >> /entrypoint.sh && \
    echo 'fi' >> /entrypoint.sh && \
    echo '' >> /entrypoint.sh && \
    echo '# Fix permissions' >> /entrypoint.sh && \
    echo 'chown -R mosquitto:mosquitto /mosquitto' >> /entrypoint.sh && \
    echo 'chmod -R 755 /mosquitto' >> /entrypoint.sh && \
    echo '' >> /entrypoint.sh && \
    echo '# Start mosquitto' >> /entrypoint.sh && \
    echo 'exec /usr/sbin/mosquitto -c /mosquitto/config/mosquitto.conf' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

# Expose MQTT and WebSocket ports
EXPOSE 1883 9001

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]

