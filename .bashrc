# .bashrc
#
# General configurations to use across machines.
# Machine specific configurations are saved in ~/.bash_aliases

[[ $- != *i* ]] && return
[ -f ~/.bashrc_prehook.sh ] && source ~/.bashrc_prehook.sh

# history ----------------------------------------------------------------------

HISTSIZE=130000
HISTFILESIZE=-1
HISTTIMEFORMAT="%F %H:%M "
HISTCONTROL=ignoredups:ignorespace:erasedups 
shopt -s histappend
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

set -o vi # set bash to vi editing mode
stty stop undef # disassociate ^S so it works for forward-search-history

# Stop bash from escaping environment variables on tab completion
# https://askubuntu.com/questions/70750
#   /how-to-get-bash-to-stop-escaping-during-tab-completion
[ $(uname -s) = "Linux" ] && shopt -s direxpand

# environment variables --------------------------------------------------------

[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin/:$PATH"

export PAGER=less
export EDITOR=$([ $(which nvim 2> /dev/null) ] && echo nvim || echo vim)

# colors -----------------------------------------------------------------------

if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || \
    eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias less='less -r'
fi

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# aliases ----------------------------------------------------------------------

alias ll='ls -lhA'
alias rm='rm -i'
alias rgrep='grep -Rls'
alias vim='nvim'
alias ed='ed --prompt "> " --extended-regex'
alias rg='rg --no-heading --line-number --column'

alias gdb='gdb -q'
alias python='python3'
alias pip='pip3'
alias pyenv='source .env-py/bin/activate'
alias mkenv='python3 -m venv .env-py'

# other sources ----------------------------------------------------------------

source-dir() {
  local f
  for f in $(find $1 -name '*.sh' | sort); do source $f; done
}

[ -d ~/.bashrc.d ] && source-dir ~/.bashrc.d || true
[ -d ~/.bash_aliases.d ] && source-dir ~/.bash_aliases.d || true
