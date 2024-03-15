# .bashrc
#
# General configurations to use across machines.
# Machine specific configurations are saved in ~/.bash_aliases

# history ----------------------------------------------------------------------

HISTSIZE=130000
HISTFILESIZE=-1
HISTTIMEFORMAT="%F %H:%M" # date and time for each entry
HISTCONTROL=ignoredups:ignorespace:erasedups # don't put duplicate lines in the history
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

set -o vi # set bash to vi editing mode
stty stop undef # disassociate ^S so it works for forward-search-history

# Stop bash from escaping environment variables on tab completion
# https://askubuntu.com/questions/70750
#   /how-to-get-bash-to-stop-escaping-during-tab-completion
[ $(uname -s) = "Darwin" ] || shopt -s direxpand

# Prevent overwriting existing files with the > operator
# Use >! to force files to be overwritten
# set -o noclobber

# environment variables --------------------------------------------------------

if [ -d "$HOME/.local/bin" ]; then export PATH="$HOME/.local/bin:$PATH"; fi

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

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# aliases ----------------------------------------------------------------------

# C/Asm
alias gdb='gdb -q'

# Python related
alias python=python3
alias pip=pip3
alias pyenv='source .env-py/bin/activate'
alias mkenv='python3 -m venv .env-py'

alias rgrep='grep -Rls'
alias ll='ls -lhA'
alias rm='rm -i'

alias vim='nvim'

# Source computer specific aliases
[ -f ~/.bash_aliases ] && . ~/.bash_aliases
