#!/bin/bash

# Check Bluetooth status
status=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

if [[ "$status" == "yes" ]]; then
  bluetoothctl power off
  notify-send "Bluetooth" "Turned off"
else
  bluetoothctl power on
  notify-send "Bluetooth" "Turned on"
fi
