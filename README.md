# **mqtt-container**

## **Instruction**

Run the following command:

```bash
# clone this repository
git clone https://github.com/Bengkel-Inovasi/mqtt-container.git

# initiate MQTT volume with credential
./setup.sh -u YOUR_USERNAME -p YOUR_PASSWORD # change accordingly

# run the docker
sudo docker compose up -d
```

To add another credentials, re-run the script with `-u` and `-p` flag.
To cleanup:

```bash
# stop and delete the container
sudo docker container stop mqtt-mqtt-1  # adjust the name if needed
sudo docker container rm mqtt-mqtt-1    # adjust the name if needed

# cleanup
./cleanup.sh
```
