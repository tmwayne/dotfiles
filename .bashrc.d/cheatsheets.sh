#!/bin/bash
# cheatsheets.sh
# Copyright (c) 2022 Tyler Wayne
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

CHEATSHEETS_DIR=${CHEATSHEETS_DIR:-$HOME/.cheatsheets}

# matches ./dir/filename.ext and outputs dir/filename
# ignores hidden files and directories
_cs_list() {
  (cd $CHEATSHEETS_DIR && \
    find . -not -path './.*' -type f \
      | perl -nle 'print $1 if m@./(.+)\.\S+@')
  
}

cs() {

  local usage="Usage: cs [-e] cheatsheet"

  local help="\
$usage
It's not cheating if you don't get caught..

Options:
  -e, --edit                Edit a cheatsheet
  -l, --list                List cheatsheets
  -h, --help                Print this help
  -V, --version             Print version info"

  local version="\
Cheatsheets v1.0.0
Copyright (c) 2022 Tyler Wayne
Licensed under the Apache License, Version 2.0

Written by Tyler Wayne."

  # Default args
  local default="cheat"
  local action=$default

  # Command-line arguments
  local arg
  for arg in "$@"; do
    shift
    case "$arg" in
      --edit)         set -- "$@" "-e" ;;
      --list)         set -- "$@" "-l" ;;
      --help)         set -- "$@" "-h" ;;
      --version)      set -- "$@" "-V" ;;
      --*)            echo "cs: unrecognized option '$arg'" >&2
                      echo "Try 'cs --help' for more information."
                      return 2 ;;
      *)              set -- "$@" "$arg"
    esac
  done

  OPTIND=1
  while getopts ":ehlV" opt; do
    case $opt in
      e)  action="edit" ;;
      h)  echo "$help"; return 0 ;;
      l)  action="list" ;;
      V)  echo "$version"; return 0 ;;
      \?) echo "cs: unrecognized option '-$OPTARG'" >&2
          echo "Try 'cs --help' for more information."
          return 2 ;;
    esac
  done
  shift $((OPTIND-1))

  local cs_name cs_path nargs

  cs_name=$1
  cs_path=$CHEATSHEETS_DIR/$cs_name.txt
  nargs=$#

  _cs_edit() {
    if [ $nargs -ne 1 ]; then
      echo $usage
      return 1
    fi
    mkdir -p $CHEATSHEETS_DIR
    if [ ! -f "$cs_path" ]; then
      echo "cs: no cheatsheet named $cs_name" >&2
      return 3;
    fi
    $EDITOR $cs_path
  }

  _cs_cheat() {
    if [ -f "$cs_path" ]; then
      # On OSX, leading white space is added to wc output. Use awk to remove it.
      local file_length=`wc -l $cs_path | awk '{$1=$1}1' | cut -d' ' -f1`
      local term_length=`tput lines`

      # Page the cheatsheet if it's longer than the terminal
      local output_pager
      if [ $file_length -gt $term_length ] && [ -n "$PAGER" ]; then
        output_pager=$PAGER
      else
        output_pager=cat
      fi

      $output_pager $cs_path
    fi
  }

  case "$action" in 
    edit)   _cs_edit  ;;
    list)   _cs_list  ;;
    cheat)  _cs_cheat ;;
    *)     echo "Error: action not recognized"; return 4 ;;
  esac

}

# Tab completion ---------------------------------------------------------------

_cs_completion() {
  COMPREPLY=()
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=($(compgen -W "$(_cs_list)" -- $cur))
  return 0
}

complete -o bashdefault -F _cs_completion cs

