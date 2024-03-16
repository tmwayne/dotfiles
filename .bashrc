# .bashrc
#
# General configurations to use across machines.
# Machine specific configurations are saved in ~/.bash_aliases

[[ $- != *i* ]] && return
[ -f ~/.bashrc_prehook.sh ] && source ~/.bashrc_prehook.sh

# history ----------------------------------------------------------------------

HISTSIZE=130000
HISTFILESIZE=-1
HISTTIMEFORMAT="%F %H:%M" # date and time for each entry
HISTCONTROL=ignoredups:ignorespace:erasedups # don't put duplicate lines in the history
shopt -s histappend
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

set -o vi # set bash to vi editing mode
stty stop undef # disassociate ^S so it works for forward-search-history

# Stop bash from escaping environment variables on tab completion
# https://askubuntu.com/questions/70750
#   /how-to-get-bash-to-stop-escaping-during-tab-completion
[ $(uname -s) = "Linux" ] && shopt -s direxpand

# Prevent overwriting existing files with the > operator
# Use >! to force files to be overwritten
# set -o noclobber

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

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# aliases ----------------------------------------------------------------------

alias ll='ls -lhA'
alias rm='rm -i'
alias rgrep='grep -Rls'
alias vim='nvim'

alias gdb='gdb -q'
alias python='python3'
alias pip='pip3'
alias pyenv='source .env-py/bin/activate'
alias mkenv='python3 -m venv .env-py'

[[ -n "$TMUX" && -f ~/.tmux.sh ]] && source ~/.tmux.sh
[ -f ~/.go ] && source ~/.go
[ -f ~/.bash_aliases ] && source ~/.bash_aliases
