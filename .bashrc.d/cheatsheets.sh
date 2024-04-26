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

cs() {

  USAGE="Usage: cs [-e] cheatsheet"

  HELP="\
$USAGE
It's not cheating if you don't get caught..

Options:
  -e, --edit                Edit a cheatsheet
  -l, --list                List cheatsheets
  -h, --help                Print this help
  -V, --version             Print version info"

  VERSION="\
Cheatsheets v1.0.0
Copyright (c) 2022 Tyler Wayne
Licensed under the Apache License, Version 2.0

Written by Tyler Wayne."

  # Arguments --------------------------------------------------------------------

  # Default args
  default="cheat"
  action=$default

  # Environment variables
  cs_dir=${CHEATSHEETS_DIR:-$HOME/.cheatsheets}

  # Command-line arguments
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
      h)  echo "$HELP"; return 0 ;;
      l)  action="list" ;;
      V)  echo "$VERSION"; return 0 ;;
      \?) echo "cs: unrecognized option '-$OPTARG'" >&2
          echo "Try 'cs --help' for more information."
          return 2 ;;
    esac
  done
  shift $((OPTIND-1))

  cs=$cs_dir/$1.txt
  nargs=$#

  # Main -------------------------------------------------------------------------

  # TODO: if file doesn't exist, copy a cheatsheet template and open that.
  edit() {
    if [ $nargs -lt 1 ]; then
      echo $USAGE
      return 1
    fi
    mkdir -p $(dirname $cs)
    $EDITOR $cs
  }

  cheat() {
    if [ -f "$cs" ]; then
      # On OSX, leading white space is added to wc output. Use awk to remove it.
      file_length=`wc -l $cs | awk '{$1=$1}1' | cut -d' ' -f1`
      term_length=`tput lines`

      # Page the cheatsheet if it's longer than the terminal
      if [ $file_length -gt $term_length ] && [ -n "$PAGER" ]; then
        output_pager=$PAGER
      else
        output_pager=cat
      fi

      $output_pager $cs
    fi
  }

  list() {
    # Strip dirname and suffix
    ls $cs_dir/*.txt | sed 's#.*/\(.*\)\..*#\1#'
  }

  case "$action" in 
    edit)   edit  ;;
    cheat)  cheat ;;
    list)   list  ;;
    *)     echo "Error: action not recognized"; return 3 ;;
  esac

}
