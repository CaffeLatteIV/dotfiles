#!/bin/bash

random_font() {
  font_dir="/usr/share/figlet/fonts"
  valid_fonts_file="$HOME/dotfiles/banner/valid_fonts.txt"
  mapfile -t font_list <"$valid_fonts_file"
  count=${#font_list[@]}
  random=$((RANDOM % count))
  random_font=${font_list[$random]}
  figlet -f "$font_dir/$random_font" -t "CaffeLatte" | lolcat
}
one_liner() {
  joke_file="$HOME/dotfiles/banner/jokes"
  mapfile -t jokes <"$joke_file"
  random=$((RANDOM % ${#jokes[@]}))
  printf "\n${jokes[$random]}\n" | lolcat
}

random_font $n1
one_liner $n2
