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
export SBX_EP1="25fbda1e-5ae6-11e5-b577-22000b47140e"
export SBX_EP2="25fbda23-5ae6-11e5-b577-22000b47140e"
export TST_EP1="abf759c4-687b-11e5-8e26-22000b5e887b"
export TST_EP2="aa87ded9-687b-11e5-8e26-22000b5e887b"

# GITHUB Token
export GITHUB_TOKEN_LOC=~/.github-token
