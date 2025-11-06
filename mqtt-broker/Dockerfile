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

# Copy the entrypoint script
COPY mqtt-broker/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Expose MQTT and WebSocket ports
EXPOSE 1883 9001

# Set the entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]

