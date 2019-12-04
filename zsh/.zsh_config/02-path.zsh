##
# set PATH
##
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# add ~/bin , ~/.local/bin , ~/.cabal/bin
PATH="$HOME/.local/bin:$HOME/.cabal/bin:$HOME/bin:$PATH"
# add hextc
PATH="$PATH:$HOME/.hextc"
# add pyenv and pyenv shims to path, set pyenv dir
PYENV_ROOT="$HOME/.pyenv"
PYENV_SHIMS="$HOME/.pyenv/shims"
PATH="$PATH:$PYENV_SHIMS:$PYENV_ROOT/bin"

export PYENV_ROOT
export PATH
##
# end setting PATH
##
