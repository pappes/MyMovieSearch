#!/bin/bash

# This script automates the Android wireless debugging pairing and connection process.
# It assumes a static IP address for the Android device.

# --- Configuration ---
# You can set a default IP address here if you always use the same one.
# Leave empty if you prefer to always enter it.
DEFAULT_ANDROID_IP="192.168.0.33"

# --- Global Variables (will be set by functions) ---
ANDROID_IP=""
PAIRING_PORT=""
CONNECTION_PORT=""

# --- Functions ---

# Function to check if adb is installed
check_adb() {
    if ! command -v adb &> /dev/null
    then
        echo "Error: adb command not found."
        echo "Please ensure Android SDK Platform Tools are installed and 'adb' is in your system's PATH."
        exit 1
    fi

    export ADB_MDNS_OPENSCREEN=1
    adb kill-server
    adb start-server
}

# Function to get a port for a specific service and IP
# Arguments: $1 = service_name, $2 = device_ip
get_port_for_service() {
    local service_name=$1
    local device_ip=$2
    
    echo "Searching for $service_name on $device_ip..." >&2
    
    # Attempt to find the service multiple times in case it's not immediately available
    for i in {1..5}; do
        # Use awk to extract the last field after the colon, which is the port
        # tr -d '\r' handles potential Windows line ending issues in WSL/Git Bash
        PORT=$(adb mdns services | grep "$service_name" | grep "$device_ip" | awk -F':' '{print $NF}' | tr -d '\r')
        if [ -n "$PORT" ]; then
            echo "Found $service_name port: $PORT" >&2
            echo "$PORT" # Return the port
            return 0
        fi
        echo "Retrying $service_name discovery... (Attempt $i/5)" >&2
        sleep 2 # Delay between retries
    done
    
    if [ -z "$PORT" ]; then
        read -p "Enter your Android device's port: " PORT >&2
        echo "$PORT" # Return the port
        return 0
    fi

    if [ -z "$PORT" ]; then
        echo "Error: Could not find $service_name for IP $device_ip." >&2
        return 1
    fi

}

# Function to get the Android device's IP address from the user
get_android_ip() {
    if [ -z "$DEFAULT_ANDROID_IP" ]; then
        read -p "Enter your Android device's static IP address: " ANDROID_IP
    else
        ANDROID_IP="$DEFAULT_ANDROID_IP"
        echo "Using default Android IP address: $ANDROID_IP"
        read -p "Press Enter to continue or type a new IP and press Enter: " user_input
        if [ -n "$user_input" ]; then
            ANDROID_IP="$user_input"
        fi
    fi

    if [ -z "$ANDROID_IP" ]; then
        echo "Error: Android IP address cannot be empty."
        exit 1
    fi
}

# Function to handle the pairing process
pair_device() {
    echo ""
    echo "Please ensure your Android device has Wireless Debugging enabled and is on the 'Pair device with pairing code' screen."
    echo "The pairing port and code will be displayed there."
    echo ""

    # Discover Pairing Port
    PAIRING_PORT=$(get_port_for_service "_adb-tls-pairing._tcp." "$ANDROID_IP")
    if [ $? -ne 0 ]; then
        echo "Please ensure 'Wireless debugging' is enabled and 'Pair device with pairing code' is open on your Android device."
        return 1
    fi

    # Get Pairing Code from User
    read -p "Enter the 6-digit pairing code displayed on your Android device: " PAIRING_CODE

    if [ -z "$PAIRING_CODE" ] || ! [[ "$PAIRING_CODE" =~ ^[0-9]{6}$ ]]; then
        echo "Error: Invalid pairing code. It must be a 6-digit number."
        return 1
    fi

    # Initiate Pairing
    echo "Attempting to pair with device..."
    echo adb pair "$ANDROID_IP:$PAIRING_PORT" "$PAIRING_CODE" 
    PAIR_OUTPUT=$(adb pair "$ANDROID_IP:$PAIRING_PORT" "$PAIRING_CODE" 2>&1)
    if echo "$PAIR_OUTPUT" | grep -q "Successfully paired"; then
        echo "Pairing successful!"
        return 0
    else
        echo "Pairing failed."
        echo "ADB Output: $PAIR_OUTPUT"
        echo "Please double-check the IP address, pairing port, and pairing code on your Android device."
        return 1
    fi
}

# Function to handle the connection process
connect_device() {
    echo ""
    echo "Attempting to connect to device..."

    # Discover Connection Port
    CONNECTION_PORT=$(get_port_for_service "_adb-tls-connect._tcp." "$ANDROID_IP")
    if [ $? -ne 0 ]; then
        echo "Could not find the connection port. This might happen if the device is not yet ready or the service is not broadcasting."
        echo "You might need to manually connect using 'adb connect $ANDROID_IP:XXXXX' where XXXXX is the port shown on your device."
        return 1
    fi

    echo adb connect "$ANDROID_IP:$CONNECTION_PORT"
    # Initiate Connection with retries
    for i in {1..5}; do # 5 retries with 2-second sleep = max 10 seconds wait
        CONNECT_OUTPUT=$(adb connect "$ANDROID_IP:$CONNECTION_PORT" 2>&1)
        if echo "$CONNECT_OUTPUT" | grep -q "connected to"; then
            echo "Connection successful!"
            return 0
        fi
        echo "Connection attempt failed. Retrying... (Attempt $i/5)"
        sleep 2 # Delay between retries
    done
    
    echo "Connection failed after multiple attempts."
    echo "ADB Output: $CONNECT_OUTPUT"
    echo "Please ensure your Android device is still on the Wi-Fi network and Wireless debugging is active."
    return 1
}

# Main orchestration function
main() {
    echo "--- Android Wireless Debugging Automation ---"

    # 1. Check for adb installation
    check_adb

    # 2. Get Android Device IP Address
    get_android_ip

    # 3. Pair the device
    if ! pair_device; then
        echo "Script terminated due to pairing failure."
        exit 1
    fi

    # 4. Connect to the device
    if ! connect_device; then
        echo "Script terminated due to connection failure."
        exit 1
    fi

    echo ""
    echo "Verifying connected devices:"
    adb devices

    echo ""
    echo "Wireless debugging setup complete!"
    echo "You can now run adb commands like 'adb shell', 'adb install <apk_file>', etc."
}

# Execute the main function
main
