#!/bin/bash


random_font(){
  banner=$1
  font="chunky"
  case "$banner" in
    1) font="Chunky"
    ;;
    2) font="Letters"
    ;;
    3) font="smshadow"
    ;;
    4) font="script"
    ;;
    5) font="mini"
    ;;
    6) font="bubble"
    ;;
    7) font="digital"
    ;;
    8) font="banner" 
    ;;
    *) font="Isometric2" 
    ;;
  esac
  figlet -f $font -c "CaffeLatte" | lolcat

}
one_liner(){
  case "$1" in 
    1) word="Why don't jokes work in octal? Because 7 10 11."
    ;;
    2) word="I could tell you a joke about UDP but I don't know if you would get it."
    ;;
    3) word="There are only two difficult problems in computer science: naming things, cache invalidation, and off-by-one errors."
    ;;
    4) word="You just have to git gud."
    ;;
    5) word=".titanic { float:none;}"
    ;;
    6) word="There are two major products of Berkeley, CA -- LSD and UNIX. We don't believe this to be strictly by coincidence."
    ;;
    7) word="May the source be with you."
    ;;
    8) word="There is no place like ~"
    ;;
    9) word="One of my most productive days was throwing away 1000 lines of code.\nKen Thomson"
    ;;
    10) word="Hackers do it with brute force."
    ;;
    11) word="The \"S\" in \"IoT\" stands for security."
    ;;
    *)
    ;;
   esac
    printf "\n$word\n" | lolcat 
}


n1=$((RANDOM % 8 +1))
n2=$((RANDOM % 11 +1 ))
random_font "$n1"
one_liner "$n2"

