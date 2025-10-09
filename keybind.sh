#! /usr/bin/bash

echo 'Remapping numpad + and - to ` ~'
xmodmap -e 'keycode  86 = grave'
xmodmap -e 'keycode  82 = asciitilde'
echo 'Done remapping'
