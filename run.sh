#!/bin/bash

ROLE=$1  # pass 'phone' or 'pc' as an argument
PORT=9999  # Define the port for streaming
PC_IP="192.168.1.100"  # Replace with your PC's local IP

if [[ -z "$ROLE" ]]; then
    echo "Usage: $0 [phone|pc]"
    exit 1
fi

if [[ "$ROLE" == "phone" ]]; then
    echo "Starting microphone streaming from phone..."
    
    # Start PulseAudio (ignore warnings)
    pulseaudio --start &>/dev/null

    # Stream audio from phone's mic (without -q option)
    parec --format=s16le --rate=44100 --channels=1 | nc "$PC_IP" "$PORT"

elif [[ "$ROLE" == "pc" ]]; then
    echo "Receiving audio on PC..."
    
    # Start PulseAudio (ignore warnings)
    pulseaudio --start &>/dev/null

    # Receive audio and play it on PC
    nc -l -p "$PORT" | pacat --format=s16le --rate=44100 --channels=1

else
    echo "Invalid role! Use 'phone' or 'pc'."
    exit 1
fi
