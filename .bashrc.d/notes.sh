#!/bin/bash
# notes.sh
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

NOTES_DIR=${NOTES_DIR:-$HOME/.notes/}

# matches ./dir/filename.ext and outputs dir/filename
# ignores hidden files and directories
_notes_list() {
  (cd $NOTES_DIR && \
    find . -not -path './.*' -type f \
      | perl -nle 'print $1 if m@./(.+)\.\S+@')
}

notes() {

  local usage="Usage: notes note [...]"

  local help="\
$usage
Never lose 'em again..

Options:
  -h, --help                Print this help
  -l, --list                List notes
  -V, --version             Print version info"

  local version="\
Notes v1.0.0
Copyright (c) 2022 Tyler Wayne
Licensed under the Apache License, Version 2.0

Written by Tyler Wayne."

  if [ $# -lt 1 ]; then
    echo $usage
    return 1
  fi

  # Command-line arguments
  local arg
  for arg in "$@"; do
    shift
    case "$arg" in
      --help)         set -- "$@" "-h" ;;
      --list)         set -- "$@" "-l" ;;
      --version)      set -- "$@" "-V" ;;
      --*)            echo "notes: unrecognized option '$arg'" >&2
                      echo "Try 'notes --help' for more information."
                      return 2 ;;
      *)              set -- "$@" "$arg"
    esac
  done

  OPTIND=1
  while getopts ":hlV" opt; do
    case $opt in
      h)  echo "$help"; return 0 ;;
      l)  _notes_list; return 0 ;;
      V)  echo "$version"; return 0 ;;
      \?) echo "notes: unrecognized option '-$OPTARG'" >&2
          echo "Try 'notes --help' for more information."
          return 2 ;;
    esac
  done
  shift $((OPTIND-1))

  NOTES_DIR=${NOTES_DIR:-$HOME/.notes/}

  local args=($@) # Accept a list of notes
  local notes=(${args[@]/#/$NOTES_DIR})
  notes=${notes[@]/%/.txt}

  if [ -z "$EDITOR" ]; then
    echo "Error: EDITOR not set"
    return 1
  fi
  $EDITOR $notes # Create a new note if one isn't found

}

# Tab completion ---------------------------------------------------------------

_notes_completion() {
  COMPREPLY=()
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=($(compgen -W "$(_notes_list)" -- $cur))
  return 0
}

complete -o bashdefault -F _notes_completion notes

