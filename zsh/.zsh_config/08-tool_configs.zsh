# configure rbenv
eval "$(rbenv init -)"


# kitchen testing should use dokken if possible
export KITCHEN_YAML=.kitchen.yml
export KITCHEN_LOCAL_YAML=.kitchen.dokken.yml


# needed for the load/unload keys funcs
export SSH_AUTH_SOCK=~/.ssh/ssh-agent.$(ec2metadata --instance-id).sock

# explicit default to autodetect
export EC2SSH_AUTODETECT=1
export EC2SSH_DISABLE_KNOWN_HOSTS=1

# endpoint IDs
export GO_EP1='ddb59aef-6d04-11e5-ba46-22000b92c6ec'
export GO_EP2='ddb59af0-6d04-11e5-ba46-22000b92c6ec'
export SEARCH_TEST_EP='616aeee4-8bec-11e6-b047-22000b92c261'

# GITHUB Token
export GITHUB_TOKEN_LOC=~/.github-token

if [ -z "$TMUX" ]; then
    tmux attach
else
    export TERM=xterm-256color  # nothing else worked, yeesh...
fi

# setup NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
