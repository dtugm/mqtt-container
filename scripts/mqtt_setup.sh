#!/bin/bash
#
# A silent script to initialize the Mosquitto directory structure,
# copy the config, optionally add a user, and fix permissions.
#
# Only prints messages on error, or a single "Setup success" on success.
#

set -e # Exit immediately if any command fails

# --- Configuration ---
BASE_DIR="./mosquitto"
CONFIG_DIR="$BASE_DIR/config"
DATA_DIR="$BASE_DIR/data"
LOG_DIR="$BASE_DIR/log"

SOURCE_CONF="./mosquitto.conf"
DEST_CONF="$CONFIG_DIR/mosquitto.conf"
PASSWORD_FILE="$CONFIG_DIR/password.txt"

USERNAME=""
PASSWORD=""

# --- Help Function ---
usage() {
  # This is an "error" / info state, so printing is fine.
  echo "Usage: $0 [-u <username> -p <password>]" >&2
  echo "" >&2
  echo "  Initializes the '$BASE_DIR' folder structure and copies '$SOURCE_CONF'." >&2
  echo "  -u: Username to add/update in '$PASSWORD_FILE'" >&2
  echo "  -p: Password for the user" >&2
  echo "  -h: Show this help message" >&2
  exit 1
}

# --- Parse Arguments ---
while getopts ":u:p:h" opt; do
  case $opt in
    u) USERNAME="$OPTARG" ;;
    p) PASSWORD="$OPTARG" ;;
    h) usage ;;
    \?) echo "Error: Invalid option: -$OPTARG" >&2; usage ;;
    :) echo "Error: Option -$OPTARG requires an argument." >&2; usage ;;
  esac
done

# --- Main Functions ---

setup_structure() {
  mkdir -p "$CONFIG_DIR"
  mkdir -p "$DATA_DIR"
  mkdir -p "$LOG_DIR"

  if [ ! -f "$SOURCE_CONF" ]; then
    echo "Error: '$SOURCE_CONF' not found in the current directory." >&2
    exit 1
  fi
  
  # Copy, overwriting if it exists
  cp "$SOURCE_CONF" "$DEST_CONF"
}

manage_user() {
  HOST_ABS_DIR=$(cd "$CONFIG_DIR" && pwd)
  CONTAINER_FILE_PATH="/workdir/$(basename "$PASSWORD_FILE")"

  CMD_OPTIONS="-b" # Batch mode
  if [ ! -f "$PASSWORD_FILE" ]; then
    CMD_OPTIONS="-c -b" # Create flag
  fi

  # Run Docker. `set -e` will catch any errors.
  # Output is not suppressed, so user will see image-pulling
  # or any errors from the docker daemon or command.
  docker run --rm \
    -v "$HOST_ABS_DIR":/workdir \
    eclipse-mosquitto \
    mosquitto_passwd $CMD_OPTIONS "$CONTAINER_FILE_PATH" "$USERNAME" "$PASSWORD"
}

fix_permissions() {
  MOSQUITTO_UID=1883
  MOSQUITTO_GID=1883
  
  if ! command -v sudo &> /dev/null; then
    echo "Error: 'sudo' command not found. Please install sudo." >&2
    exit 1
  fi

  # Run chown, suppressing its standard output and error.
  # The 'if' statement will still catch a non-zero exit code.
  if ! sudo chown -R $MOSQUITTO_UID:$MOSQUITTO_GID "$BASE_DIR" &> /dev/null; then
    echo "Error: Failed to set permissions for '$BASE_DIR'." >&2
    echo "  Please run this command manually:" >&2
    echo "  sudo chown -R $MOSQUITTO_UID:$MOSQUITTO_GID \"$BASE_DIR\"" >&2
    exit 1
  fi
}


# --- Execution ---

setup_structure

if [ -n "$USERNAME" ] && [ -n "$PASSWORD" ]; then
  manage_user
elif [ -n "$USERNAME" ] || [ -n "$PASSWORD" ]; then
  echo "Error: Both -u (username) and -p (password) must be provided together." >&2
  usage
fi

fix_permissions

echo "Setup success."