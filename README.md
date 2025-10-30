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
```

To change the credential:

```bash
./scripts/delete_credential.sh
./scripts/create_credential.sh

# You will be re-prompted to fill the credentials.
```
