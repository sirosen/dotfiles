# configure rbenv
eval "$(rbenv init -)"
# configure fnm
if command -v fnm > /dev/null; then
  eval "$(fnm env)"
fi

# explicit default to autodetect
export EC2SSH_AUTODETECT=1
export EC2SSH_DISABLE_KNOWN_HOSTS=1

# collection IDs
export GTC1="6c54cade-bde5-45c1-bdea-f4bd71dba2cc"
export GTC2="31ce9ba0-176d-45a5-add3-f37d233ba47d"
# GITHUB Token
export GITHUB_TOKEN_LOC=~/.github-token
