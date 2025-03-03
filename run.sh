#!/bin/bash

# Define roles (phone or PC)
ROLE=$1  # pass 'phone' or 'pc' as an argument
PORT=9999  # Define the port for streaming
PC_IP="192.168.1.100"  # Replace this with your PC's local IP

if [[ -z "$ROLE" ]]; then
    echo "Usage: $0 [phone|pc]"
    exit 1
fi

if [[ "$ROLE" == "phone" ]]; then
    echo "Starting microphone streaming from phone..."
    
    # Start PulseAudio (if not running)
    pulseaudio --start

    # Stream audio from phone's mic
    parec --format=s16le --rate=44100 --channels=1 | nc -q 0 "$PC_IP" "$PORT"

elif [[ "$ROLE" == "pc" ]]; then
    echo "Receiving audio on PC..."
    
    # Start PulseAudio (if not running)
    pulseaudio --start

    # Receive audio and play it on PC
    nc -l -p "$PORT" | pacat --format=s16le --rate=44100 --channels=1

else
    echo "Invalid role! Use 'phone' or 'pc'."
    exit 1
fi
