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

# _go_comp() {
#     local curw
#     COMPREPLY=()
#     curw=${COMP_WORDS[COMP_CWORD]}
#     COMPREPLY=($(compgen -W '$(_go_list)' -- $curw))
#     return 0
# }

_go_assign() {
    export $1=$(_go_dir $1)
}

_go_unassign() {
    unset $1
}

go_dir() {
    local dir=$(_go_dir $1)
    cd $dir
}

go_set() {
    [ $# -eq 2 ] || return 1
    echo "$2" > $GO_DIR/$1
    _go_assign $1
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
    _go_unassign $dir
  done
}

go() {

  Help() {
      echo "Usage: go [<alias>|<path>]"
      echo
      echo "Commands:"
      echo "  help                      Print this help."
      echo "  ls                        List all registered directories"
      echo "  rm <alias>                Unregister an alias"
      echo "  set <alias> <path>        Register an alias to a directory"
  }

  # Parse optional long arguments
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
  while getopts ":h" opt; do
    case $opt in
      h)  Help; return 0 ;;
      \?) >&2 echo "go: unrecognized option '-$OPTARG'"
          echo "Try 'go --help' for more information."
          return 2 ;;
    esac
  done
  shift $((OPTIND-1))

  local command=$1
  [ -z "$command" ] || shift

  case "$command" in 
    # add)    go_add $@ ;;
    help)   Help; return 0 ;;
    ls)     go_ls ;;
    rm)     go_rm  $@ ;;
    set)    go_set $@ ;;
    *)      set -- $command $@; go_dir $@ ;;
  esac

}

go_init() {
  [ -n "$GO_ENV_INIT" ] && return

  export GO_DIR="$HOME/.go.d"
  [ -d "$GO_DIR" ] || mkdir -p $GO_DIR

  for dir in $(_go_list); do
    _go_assign $dir
  done

  # TODO: figure out how to make completion work
  # complete -o filenames -F _go_comp go
  
  export GO_ENV_INIT=1
}

go_init
