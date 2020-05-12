##
# set PATH
##
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# add ~/bin , ~/.local/bin , ~/.cabal/bin
PATH="$HOME/.local/bin:$HOME/.cabal/bin:$HOME/bin:$PATH"
# add rbenv
PATH="$HOME/.rbenv/bin:$PATH"
# add hextc
PATH="$PATH:$HOME/.hextc"
# add pyenv and pyenv shims to path, set pyenv dir
PYENV_ROOT="$HOME/.pyenv"
PYENV_SHIMS="$HOME/.pyenv/shims"
PATH="$PATH:$PYENV_SHIMS:$PYENV_ROOT/bin"
# add poetry
PATH="$PATH:$HOME/.poetry/bin"
# add globus-cli
PATH="$PATH:$HOME/.venv-globus-cli/bin"

export PYENV_ROOT
export PATH
##
# end setting PATH
##
