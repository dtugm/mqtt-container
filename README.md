# **mqtt-container**

## **Instruction**

Run the following command:

```bash
# clone this repository
git clone https://github.com/Bengkel-Inovasi/mqtt-container.git

# initiate the required mosquitto config folder
./scripts/init.sh

# create a credential for MQTT broker
./scripts/create_credential.sh

# You will be prompted to fill:
# Enter username:
# Enter password:

# Run the docker
sudo docker compose up -d
```

To change the credential:

```bash
./scripts/delete_credential.sh
./scripts/create_credential.sh

# You will be re-prompted to fill the credentials.
# ...

# Restart the container by simply running
sudo docker container stop mqtt-mqtt-1  # adjust the name if needed
sudo docker container rm mqtt-mqtt-1    # adjust the name if needed
sudo docker compose up -d
```
