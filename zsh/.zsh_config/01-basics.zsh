# fpath=($fpath ~/.zsh/completion)
autoload -Uz compinit && compinit
autoload bashcompinit && bashcompinit

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
DIRSTACKSIZE=1000

setopt appendhistory autocd extendedglob nomatch notify autopushd pushdsilent
unsetopt beep
bindkey -v
zstyle :compinstall filename '/home/sirosen/.zshrc'

# Key Bindings
bindkey -M vicmd '?' history-incremental-search-backward

# editor
export EDITOR=vim
