#!/bin/bash


random_font(){
  font_list=("Chunky" "Letters" "smshadow" "script" "mini" "bubble" "digital" "banner" "Isometric2")
  random=$((RANDOM % ${#font_list[@]}))
  figlet -f ${font_list[$random]} "CaffeLatte" | lolcat
}
one_liner(){
  jokes=(
    "Why don't jokes work in octal? Because 7 10 11." 
    "I could tell you a joke about UDP but I don't know if you would get it."
    "There are only two difficult problems in computer science: naming things, cache invalidation, and off-by-one errors."
    "You just have to git gud."
    ".titanic { float:none;}"
    "There are two major products of Berkeley, CA -- LSD and UNIX. We don't believe this to be strictly by coincidence."
    "May the source be with you."
    "There is no place like ~"
    "One of my most productive days was throwing away 1000 lines of code.\nKen Thomson"
    "Hackers do it with brute force."
   )
   random=$((RANDOM % ${#jokes[@]}))
   printf "\n${jokes[$random]}\n" | lolcat 
}


random_font $n1
one_liner $n2

