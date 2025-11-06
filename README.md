# **mqtt-container**

## **A. Instruction**

### **1. Initiate MQTT Credential**

```bash
# adjust <USERNAME> and <PASSWORD> accordingly
./scripts/mqtt_setup.sh -u <USERNAME> -p <PASSWORD>
```

### **2. Fill the Environment Variables on `compose.yml`**

There are some private variables need to be filled in on `compose.yml`:

- **TOKEN_PRIVATE_KEY**
- **DB_PASSWORD**
- **MQTT_USERNAME**
- **MQTT_PASSWORD**
- **POSTGRES_PASSWORD**

### **3. Compose the Docker Container**

```bash
sudo docker compose up -d
```

### **4. Accessing the API Documentation**

Open `HOSTNAME:8080/swagger` to access the API documentation.

### **5. Clearing the Container**

```bash
sudo docker compose down -v
```
