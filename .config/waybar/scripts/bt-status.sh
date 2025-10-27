#!/bin/bash

status=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

if [[ "$status" == "yes" ]]; then
  echo "On"
else
  echo "Off"
fi
