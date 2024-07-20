#!/bin/bash
# uninstall.sh
# Tyler Wayne (c) 2024

uninstall-sh() {

  this_prog=$( basename $0 )
  usage="Usage: $this_prog [-i install_dir] prog_name"

  help="\
$usage
Uninstalls program from local bin directory.

Options:
  -h, --help                Print this help.
  -i, --install-dir=DIR     Directory program is installed in.
                            Defaults to ~/.local/bin"

  ## ARGUMENTS
  ########################################

  # Default arguments
  install_dir=~/.local/bin/

  for arg in "$@"; do
    shift
    case "$arg" in
      --help)         set -- "$@" "-h" ;;
      --install-dir)  set -- "$@" "-i" ;;
      --*)            echo "$this_prog: unrecognized option '$arg'" >&2
                      echo "Try '$this_prog --help' for more information."
                      return 2 ;;
      *)              set -- "$@" "$arg"
    esac
  done

  # Command-line arguments
  OPTIND=1
  while getopts ":hi:" opt; do
    case $opt in
      h) echo -e "$help"; return 0 ;;
      i) install_dir=$( realpath $OPTARG ) ;;
      \?) echo "$this_prog: unrecognized option '-$OPTARG'" >&2
          echo "Try '$this_prog --help' for more information."
          return 2 ;;
    esac
  done
  shift $((OPTIND-1))

  prog_name=$1
  target="$install_dir"/$prog_name

  ## ASSERTIONS
  ########################################

  if [ $# -lt 1 ]; then
    echo $usage
    return 1
  fi

  ## MAIN
  ########################################

  if rm -f "$target"; then
    echo "Successfully uninstalled $prog_name!"
  else
    echo "$this_prog: error: unable to uninstall $prog_name ..." >&2
  fi

}
