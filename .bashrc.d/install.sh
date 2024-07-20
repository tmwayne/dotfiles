#!/bin/bash
# install.sh
# Tyler Wayne (c) 2024

install-sh() {

  this_prog=$( basename $0 )
  usage="Usage: $this_prog [-f] [-i install_dir] [-n prog_name] file_name"

  help="\
$usage
Installs program into local bin directory as copy or symlink.

Options:
  -c, --copy                Install a copy instead of a symlink.
  -h, --help                Print this help.
  -i, --install-dir=DIR     Directory program is installed in.
  -f, --force               Force overwrite if already exists.
                            Defaults to ~/.local/bin
  -n, --name=NAME           Name to install program as."

  ## ARGUMENTS
  ##############################

  # Default arguments
  install_dir=~/.local/bin/

  for arg in "$@"; do
    shift
    case "$arg" in
      --help)         set -- "$@" "-h" ;;
      --copy)         set -- "$@" "-c" ;;
      --install-dir)  set -- "$@" "-i" ;;
      --force)        set -- "$@" "-f" ;;
      --name)         set -- "$@" "-n" ;;
      --*)            echo "$this_prog: unrecognized option '$arg'" >&2
                      echo "Try '$this_prog --help' for more information."
                      return 2 ;;
      *)              set -- "$@" "$arg"
    esac
  done

  # Command-line arguments
  OPTIND=1
  while getopts ":hcfi:n:" opt; do
    case $opt in
      h) echo -e "$help"; return 0 ;;
      c) copy=y ;;
      i) install_dir=$( realpath $OPTARG ) ;;
      n) prog_name=$OPTARG ;;
      f) force=y ;;
      \?) echo "$this_prog: unrecognized option '-$OPTARG'" >&2
          echo "Try '$this_prog --help' for more information."
          return 2 ;;
    esac
  done
  shift $((OPTIND-1))

  file_name=$( realpath -q "$1" )

  base_name=$( basename "${file_name%%.*}" )
  prog_name=${prog_name:-$base_name}

  target="$install_dir"/$prog_name
  tmp="$target".tmp

  ## ASSERTIONS
  ##############################

  if [ $# -lt 1 ]; then
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


  ## MAIN
  ##############################

  # Check for existing file
  if [ -f "$target" ]; then
    target_exists=y
  fi

  if [ "$force" == y ]; then
    overwrite=y
  elif [ "$target_exists" == y ]; then
    read -p "$prog_name already exists. Overwrite? (y/n) [n]: " overwrite
  fi

  if [ "$target_exists" == y ] && [ "$overwrite" != y ]; then
    echo "$this_prog: error: aborting without overwriting ..." >&2
    return 1
  fi

  # Install and save whether it was success
  if [ "$copy" == y ]; then
    if cp "$file_name" "$tmp"; then successful_install=y; fi
  else
    ## ln returns an exit code of 0 even if the link it creates is broken
    ## we ensure that the link it create works
    if ln -s "$file_name" "$tmp" && realpath "$tmp" > /dev/null 2>&1; then
      successful_install=y;
    fi
  fi

  if [ "$successful_install" == y ]; then
    echo "Successfully installed $prog_name!"
    mv "$tmp" "$target"
  else
    echo "$this_prog: error: failed to install $prog_name ..." >&2
    rm -f "$tmp"
    return 1
  fi

}
