#!/bin/bash

TERM_CMD="kitty"

# Set the directory flag for your terminal:
# - For kitty: "-d" or "--directory"
# - For alacritty/foot/ghostty: "--working-directory"
DIR_FLAG="-d"

# Fallback directory
TARGET_DIR="$HOME"

# 2. Get the active window information
ACTIVE_WINDOW=$(hyprctl activewindow -j)

# Extract the window class and its PID
WINDOW_CLASS=$(echo "$ACTIVE_WINDOW" | jq -r '.class')
WINDOW_PID=$(echo "$ACTIVE_WINDOW" | jq -r '.pid')


# 3. Check if the active window is your terminal
if [ "$WINDOW_CLASS" = "$TERM_CMD" ] && [ "$WINDOW_PID" != "null" ]; then

    # Find the PID of the shell (zsh, bash, or fish) running inside this terminal window
    SHELL_PID=$(pgrep -P "$WINDOW_PID" -x "zsh" || pgrep -P "$WINDOW_PID" -x "bash" || pgrep -P "$WINDOW_PID" -x "fish")
    # If there are multiple shells for some reason, grab the first one
    SHELL_PID=$(echo "$SHELL_PID" | head -n 1)

    # If found, get its Current Working Directory (cwd)
    if [ -n "$SHELL_PID" ] && [ -d "/proc/$SHELL_PID/cwd" ]; then
        TARGET_DIR=$(readlink "/proc/$SHELL_PID/cwd")
    elif [ -d "/proc/$WINDOW_PID/cwd" ]; then
        TARGET_DIR=$(readlink "/proc/$WINDOW_PID/cwd")
    fi
fi

# 4. Launch the new terminal
$TERM_CMD $DIR_FLAG "$TARGET_DIR" &
