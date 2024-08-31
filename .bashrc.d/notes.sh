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
#
#

NOTES_DIR=${NOTES_DIR:-$HOME/.notes/}

notes() {

  USAGE="Usage: notes note [...]"

  HELP="\
$USAGE
Never lose 'em again..

Options:
  -h, --help                Print this help.
  -V, --version             Print version info."

  VERSION="\
Notes v1.0.0
Copyright (c) 2022 Tyler Wayne
Licensed under the Apache License, Version 2.0

Written by Tyler Wayne."

  if [ $# -lt 1 ]; then
    echo $USAGE
    return 1
  fi

  local arg

  # Command-line arguments
  for arg in "$@"; do
    shift
    case "$arg" in
      --help)         set -- "$@" "-h" ;;
      --version)      set -- "$@" "-V" ;;
      --*)            echo "notes: unrecognized option '$arg'" >&2
                      echo "Try 'notes --help' for more information."
                      return 2 ;;
      *)              set -- "$@" "$arg"
    esac
  done

  OPTIND=1
  while getopts ":hV" opt; do
    case $opt in
      h)  echo "$HELP"; return 0 ;;
      V)  echo "$VERSION"; return 0 ;;
      \?) echo "notes: unrecognized option '-$OPTARG'" >&2
          echo "Try 'notes --help' for more information."
          return 2 ;;
    esac
  done
  shift $((OPTIND-1))

  local args notes

  NOTES_DIR=${NOTES_DIR:-$HOME/.notes/}

  args=($@) # Accept a list of notes
  notes=(${args[@]/#/$NOTES_DIR})
  notes=${notes[@]/%/.txt}

  if [ -z "$EDITOR" ]; then
    echo "Error: EDITOR not set"
    return 1
  fi
  $EDITOR $notes # Create a new note if one isn't found

}

# Tab completion ---------------------------------------------------------------

_notes_options() {
  # matches ./dir/filename.ext and outputs dir/filename
  # TODO: currently this matches files like ./.git/objects/../. Remove these
  (cd $NOTES_DIR && find . -type f | perl -nle 'print $1 if m@./(.+)\.\S+@')
  
}

_notes_completion() {
  local cur
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=($(compgen -W "$(_notes_options)" -- $cur))
  return 0
}

complete -o bashdefault -F _notes_completion notes

