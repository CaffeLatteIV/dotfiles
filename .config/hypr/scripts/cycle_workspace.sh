#!/usr/bin/env sh 

direction="$1"  # "next" or "prev"

current=$(hyprctl activeworkspace -j | jq -r '.id')
workspaces=($(hyprctl workspaces -j | jq -r 'sort_by(.id) | .[].id'))

# find index of current workspace
for i in "${!workspaces[@]}"; do
    if [[ "${workspaces[$i]}" == "$current" ]]; then
        index=$i
        break
    fi
done

# compute next/prev
if [[ "$direction" == "next" ]]; then
    next_index=$(( (index + 1) % ${#workspaces[@]} ))
else
    next_index=$(( (index - 1 + ${#workspaces[@]}) % ${#workspaces[@]} ))
fi

next_workspace="${workspaces[$next_index]}"

# switch to the next active workspace
hyprctl dispatch workspace "$next_workspace"

