# .bash_go
# this is a refactoring of the code found:
# https://raw.github.com/smanikarnika/etc/master/.bash_go

_go_dir() {
  local dir=$1
  [ -f $GO_DIR/$1 ] && dir="$(cat $GO_DIR/$1)"
  echo $dir
}

_go_list() {
  find $GO_DIR/ -type f | xargs -n 1 -r basename
}

_go_set() {
  export $1=$(_go_dir $1)
}

_go_unset() {
  unset $1
}

go_dir() {
  local dir=$(_go_dir $1)
  cd $dir
}

go_add() {
  [ $# -eq 2 ] || return 1
  echo "$2" > $GO_DIR/$1
  _go_set $1 || (command rm $GO_DIR/$1 && return 2)
}

go_ls() {
  [ -d "$GO_DIR" ] && [ "$(ls $GO_DIR)" = "" ] && return 1
  for f in $GO_DIR/*; do
    echo "$(basename $f) -> $(cat $f)"
  done
}

go_rm() {
  [ $# -gt 0 ] || return 1
  for dir in $@; do
    rm -f $GO_DIR/$dir
    _go_unset $dir
  done
}

go() {

  local usage="Usage: go [<alias>|<path>]"

  local help="\
$usage

Commands:
  help                      Print this help.
  ls                        List all registered directories
  add <alias> <path>        Register an alias to a directory
  rm  <alias>               Unregister an alias"

  # Parse optional long arguments
  local arg
  for arg in "$@"; do
    shift
    case "$arg" in
      --help)         set -- "$@" "-h" ;;
      --*)            >&2 echo "go: unrecognized option '$arg'"
        echo "Try 'go --help' for more information."
        return 2 ;;
      *)              set -- "$@" "$arg"
    esac
  done

  # Parse optional arguments
  local OPTIND=1
  local opt
  while getopts ":h" opt; do
    case $opt in
      h)  echo -e "$help"; return 0 ;;
      \?) >&2 echo "go: unrecognized option '-$OPTARG'"
        echo "Try 'go --help' for more information."
        return 2 ;;
    esac
  done
  shift $((OPTIND-1))

  local command=$1
  [ -z "$command" ] || shift

  case "$command" in 
    help)   echo -e "$help"; return 0 ;;
    add)    go_add $@ ;;
    rm)     go_rm  $@ ;;
    ls)     go_ls ;;
    *)      set -- $command $@; go_dir $@ ;;
  esac

}

go_init() {
  [ -n "$GO_ENV_INIT" ] && return

  export GO_DIR="$HOME/.go.d"
  [ -d "$GO_DIR" ] || mkdir -p $GO_DIR

  for dir in $(_go_list); do
    _go_set $dir
  done

  export GO_ENV_INIT=1
}

go_init

# Useful aliases ---------------------------------------------------------------

gol() {
  go "$1" && ll
}

mkdgo() {
  mkdir "$@" && go "$_"
}
