# prompt_commands.sh

# Source colors if they haven't been already
shload "colors.sh"

# https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x264.html
# PROMPT_COMMAND generally should not be used to print characters directly to 
# the prompt. Characters printed outside of PS1 are not counted by Bash, which 
# will cause it to incorrectly place the cursor and clear characters. Either 
# use PROMPT_COMMAND to set PS1 or look at embedding commands.
# PROMPT_COMMAND="prompt_command"

# PS1 is the regular prompt.
# Substitutions include:
# \u username \h hostname \w current directory
# \! history number \s shell \$ $ if regular user

# adding error code to output
# https://stackoverflow.com/a/61740213
_exitstatus() {
  code=${?##0}
  echo -n ${code:+"[$code] "}
}

_basedir() {
  echo -n $(basename $PWD)
}

# Set this if it's not
command -v _scm_prompt >/dev/null || alias _scm_prompt=""

# Color codes need to be surrounded by \[ <code> \] in order not to mess up
# the command line length calculation, hence line wrapping
# https://meta.superuser.com/a/3292
_sign_="\$ "
_exitstatus_="\[$YELLOW\]\$(_exitstatus)\[$ENDCLR\]"
_basedir_="\[$LIGHT_GREEN\]\$(_basedir)\[$ENDCLR\]"
_scm_="\[$LIGHT_PURPLE\]\$(_scm_prompt)\[$ENDCLR\]"

export PS1="$_exitstatus_$_basedir_$_scm_$_sign_"
