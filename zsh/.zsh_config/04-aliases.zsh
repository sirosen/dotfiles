# colorizing aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# git aliases
alias gst='git status'
compdef _git gst=git-status
alias gm='git merge'
compdef _git gm=git-merge
alias gb='git branch'
compdef _git gb=git-branch
alias gco='git checkout'
compdef _git gco=git-checkout
alias gcv='git commit -v'
compdef _git gcv=git-commit
alias grb='git rebase'
compdef _git grb=git-rebase
alias grbi='git rebase --interactive'
compdef _git grbi=git-rebase
alias gtree='git log --graph --decorate --all'
compdef _git gtree=git-log

# microk8s aliases
# prefer shims
# alias kubectl='microk8s kubectl'
# alias helm='microk8s helm3'
