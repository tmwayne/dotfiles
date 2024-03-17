# .bashload.sh
# Try to load file from a set of directories

SHPATH=$HOME/.bash_aliases.d:$HOME/.bashrc.d

shload() {
  [ -z "$SHPATH" ] && return 1                      # path can't be empty
  list_dirs=$(echo $SHPATH | tr ':' '\n')
  for file in $@; do                                # for each file
    for d in $list_dirs; do                         # iterate over each dir
      match=$(find $d -name $file)                  # find matches

      if [[ $match = "" ]]; then continue           # check for existence

      elif [ $(echo $match | wc -w) -gt 1 ]; then   # check for uniqueness
        >&2 echo "Duplicate files found of $file"
        return 1

      elif [ -f $match ]; then
        source $match                               # source match
        return 0
      fi

    done
  done
}
