# .tmux.sh
# Shell commands for use with tmux

# these are named to align with vim naming conventions
function vsplit() {
  tmux split-window -h "$@"
}

function hsplit() {
  tmux split-window -v "$@"
}
