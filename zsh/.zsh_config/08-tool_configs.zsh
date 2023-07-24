# configure rbenv
eval "$(rbenv init -)"
# configure fnm
if command -v fnm > /dev/null; then
  eval "$(fnm env)"
fi

# explicit default to autodetect
export EC2SSH_AUTODETECT=1
export EC2SSH_DISABLE_KNOWN_HOSTS=1

# endpoint IDs
export GO_EP1='ddb59aef-6d04-11e5-ba46-22000b92c6ec'
export GO_EP2='ddb59af0-6d04-11e5-ba46-22000b92c6ec'
export SEARCH_TEST_EP='616aeee4-8bec-11e6-b047-22000b92c261'

# GITHUB Token
export GITHUB_TOKEN_LOC=~/.github-token
