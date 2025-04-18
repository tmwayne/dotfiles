# .tmux.sh
# Shell commands for use with tmux

if [ -n "$TMUX" ]; then

  # these are named to align with vim naming conventions
  alias vsplit="tmux split-window -h"
  alias hsplit="tmux split-window -v"
  alias close="tmux kill-pane -t"

fi
