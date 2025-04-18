# colors.sh

# https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
# Use \033[0;... to unbold
export BLACK="\033[0;30m"
export RED="\033[0;31m"
export GREEN="\033[0;32m"
export BROWN="\033[0;33m"
export BLUE="\033[0;34m"
export PURPLE="\033[0;35m"
export CYAN="\033[0;36m"
export LIGHT_GRAY="\033[0;37m"

export DARK_GRAY="\033[1;30m"
export LIGHT_RED="\033[1;31m"
export LIGHT_GREEN="\033[1;32m"
export YELLOW="\033[1;33m"
export LIGHT_BLUE="\033[1;34m"
export LIGHT_PURPLE="\033[1;35m"
export LIGHT_CYAN="\033[1;36m"
export WHITE="\033[1;37m"
export ENDCLR="\e[0m"

# https://tldr.org/HOWTO/Bash-Prompt-HOWTO/x329.html
# This file echoes a bunch of color codes to the terminal to demonstrate 
# what's available. Each line is the color code of one forground color,
# out of 17 (default + 16 escapes), followed by a test use of that color 
# on all nine background colors (default + 8 escapes).
test-colors() {
  local T='gYw'   # The test text

  echo -e "\n                 40m     41m     42m     43m\
     44m     45m     46m     47m";

  local FGs BG
  for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
             '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
             '  36m' '1;36m' '  37m' '1;37m';
    do FG=${FGs// /}
    echo -en " $FGs \033[$FG  $T  "
    for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
      do echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m";
    done
    echo;
  done
  echo
}
