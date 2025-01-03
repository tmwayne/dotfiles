#!/bin/bash
# install.sh
# Tyler Wayne (c) 2024

install-sh() {

  local this_prog=${FUNCNAME##*/}
  local usage="Usage: $this_prog [-f] [-i install_dir] [-n prog_name] file_name"

  local help="\
$usage
Installs program into local bin directory as copy or symlink.

Options:
  -c, --copy                Install a copy instead of a symlink.
  -h, --help                Print this help.
  -i, --install-dir=DIR     Directory program is installed in.
                            Defaults to ~/.local/bin
  -f, --force               Force overwrite if already exists.
  -n, --name=NAME           Name to install program as."

  # Default arguments
  local install_dir=~/.local/bin/

  local arg
  for arg in "$@"; do
    shift
    case "$arg" in
      --help)         set -- "$@" "-h" ;;
      --copy)         set -- "$@" "-c" ;;
      --install-dir)  set -- "$@" "-i" ;;
      --force)        set -- "$@" "-f" ;;
      --name)         set -- "$@" "-n" ;;
      --*)            echo "$this_prog: unrecognized option '$arg'" >&2
                      echo "Try '$this_prog --help' for more information." >&2
                      return 2 ;;
      *)              set -- "$@" "$arg"
    esac
  done

  # Command-line arguments
  local OPTIND=1
  local opt
  while getopts ":hcfi:n:" opt; do
    case $opt in
      h) echo -e "$help"; return 0 ;;
      c) local copy=y ;;
      i) local install_dir=$( realpath $OPTARG ) ;;
      n) local prog_name=$OPTARG ;;
      f) local force=y ;;
      \?) echo "$this_prog: unrecognized option '-$OPTARG'" >&2
          echo "Try '$this_prog --help' for more information." >&2
          return 2 ;;
    esac
  done
  shift $((OPTIND-1))

  local file_name=$( realpath -q "$1" )

  local base_name=$( basename "${file_name%%.*}" )
  local prog_name=${prog_name:-$base_name}

  local target="$install_dir"/$prog_name
  local tmp="$target".tmp

  if (( $# < 1 )); then
    echo $usage
    return 1
  fi

  if [ ! -d "$install_dir" ]; then
    echo "$this_prog: error: target directory $install_dir does not exist ..." >&2
    return 1
  fi

  if [ ! -f "$file_name" ]; then
    echo "$this_prog: error: $file_name not found ..." >&2
    return 1
  fi

  # Check for existing file
  if [ -f "$target" ]; then
    local target_exists=y
  fi

  local overwrite
  if [ "$force" == y ]; then
    overwrite=y
  elif [ "$target_exists" == y ]; then
    read -p "$prog_name already exists. Overwrite? (y/n) [n]: " overwrite
  fi

  if [ "$target_exists" == y ] && [ "$overwrite" != y ]; then
    echo "$this_prog: error: aborting without overwriting ..." >&2
    return 1
  fi

  local successful_install
  # Install and save whether it was success
  if [ "$copy" == y ]; then
    if cp "$file_name" "$tmp"; then successful_install=y; fi
  else
    # ln returns an exit code of 0 even if the link it creates is broken
    # we ensure that the link it create works
    if ln -s "$file_name" "$tmp" && realpath "$tmp" &> /dev/null; then
      successful_install=y;
    fi
  fi

  if [ "$successful_install" == y ]; then
    # echo "Successfully installed $prog_name!"
    mv "$tmp" "$target"
  else
    echo "$this_prog: error: failed to install $prog_name ..." >&2
    rm -f "$tmp"
    return 1
  fi

}

uninstall-sh() {

  local this_prog=${FUNCNAME##*/}
  local usage="Usage: $this_prog [-i install_dir] prog_name"

  local help="\
$usage
Uninstalls program from local bin directory.

Options:
  -h, --help                Print this help.
  -i, --install-dir=DIR     Directory program is installed in.
                            Defaults to ~/.local/bin"

  # Default arguments
  local install_dir=~/.local/bin/

  local arg
  for arg in "$@"; do
    shift
    case "$arg" in
      --help)         set -- "$@" "-h" ;;
      --install-dir)  set -- "$@" "-i" ;;
      --*)            echo "$this_prog: unrecognized option '$arg'" >&2
                      echo "Try '$this_prog --help' for more information." >&2
                      return 2 ;;
      *)              set -- "$@" "$arg"
    esac
  done

  # Command-line arguments
  local OPTIND=1
  local opt
  while getopts ":hi:" opt; do
    case $opt in
      h) echo -e "$help"; return 0 ;;
      i) local install_dir=$( realpath $OPTARG ) ;;
      \?) echo "$this_prog: unrecognized option '-$OPTARG'" >&2
          echo "Try '$this_prog --help' for more information." >&2
          return 2 ;;
    esac
  done
  shift $((OPTIND-1))

  local prog_name=$1
  local target="$install_dir"/$prog_name

  if (( $# < 1 )); then
    echo $usage
    return 1
  fi

  if ! rm -f "$target"; then
    echo "$this_prog: error: unable to uninstall $prog_name ..." >&2
  fi

}
