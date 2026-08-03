if ! pgrep -f bluetui >/dev/null; then
  kitty sh -c 'bluetui'
else
  pkill bluetui
fi
