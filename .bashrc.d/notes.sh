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

  # Arguments ------------------------------------------------------------------

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

  local notes_dir args notes

  notes_dir=${NOTES_DIR:-$HOME/.notes/}

  args=($@) # Accept a list of notes
  notes=(${args[@]/#/$notes_dir})
  notes=${notes[@]/%/.txt}

  # Main -----------------------------------------------------------------------

  if [ -z "$EDITOR" ]; then
    echo "Error: EDITOR not set"
    return 1
  fi
  $EDITOR $notes # Create a new note if one isn't found

}
