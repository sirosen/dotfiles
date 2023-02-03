##
# set PATH
##
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin

# add ~/bin , ~/.local/bin
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
# rust
PATH="$HOME/.cargo/bin:$PATH"
# add rbenv
PATH="$HOME/.rbenv/bin:$PATH"
# add hextc
PATH="$PATH:$HOME/.hextc"
# add pyenv and pyenv shims to path, set pyenv dir
PYENV_ROOT="$HOME/.pyenv"
PYENV_SHIMS="$HOME/.pyenv/shims"
PATH="$PYENV_SHIMS:$PYENV_ROOT/bin:$PATH"
# add poetry
PATH="$PATH:$HOME/.poetry/bin"
# fnm
PATH="$PATH:$HOME/.fnm"

export PYENV_ROOT
export PATH
##
# end setting PATH
##
