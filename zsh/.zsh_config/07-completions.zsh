,load-completions() {
    if [ -d ~/.zsh_completions ]; then
        for fname in $(ls ~/.zsh_completions); do
            . ~/.zsh_completions/"$fname"
        done
    fi
}

,reconfigure-completions() {
    rm -rf ~/.zsh_completions/
    mkdir ~/.zsh_completions/

    # just
    if type just > /dev/null; then
        just --completions zsh > ~/.zsh_completions/just.zsh
    fi

    # globus-cli
    if type globus > /dev/null; then
        globus --zsh-completer > ~/.zsh_completions/globus.zsh
    fi

    # ec2ssh
    if type ec2ssh > /dev/null; then
        _ec2ssh_print_completion --shell zsh > ~/.zsh_completions/ec2ssh.zsh
    fi

    # pip-tools
    if type pip-compile > /dev/null; then
        _PIP_COMPILE_COMPLETE=zsh_source pip-compile > ~/.zsh_completions/pip-tools.zsh
        _PIP_SYNC_COMPLETE=zsh_source pip-sync >> ~/.zsh_completions/pip-tools.zsh
    fi

    ,load-completions
}

#compdef init-project-template
_init_project_template_zsh_complete() {
    _arguments "*: :(($(ls ~/.project-templates/)))"
}
compdef _init_project_template_zsh_complete init-project-template

,load-completions
