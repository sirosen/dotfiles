# configure EC2-specific things
if command -v ec2metadata > /dev/null; then
  # needed for the load/unload keys funcs
  export SSH_AUTH_SOCK=~/.ssh/ssh-agent.$(ec2metadata --instance-id).sock

  # auto-tmux setup
  if [[ -z "$TMUX" ]]; then
    tmux attach
  else
    export TERM=xterm-256color  # nothing else worked, yeesh...
  fi
fi
