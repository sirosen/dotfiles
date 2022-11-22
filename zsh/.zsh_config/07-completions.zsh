# globus-cli completer
if type globus > /dev/null; then
    eval "$(globus --zsh-completer)"
fi

# globus-automate completer
if type globus-automate > /dev/null; then
    eval "$(globus-automate --show-completion)"
fi

# ec2ssh completer
if type ec2ssh > /dev/null; then
    eval "$(_ec2ssh_print_completion --shell zsh)"
fi

#compdef init-project-template
_init_project_template_zsh_complete() {
    _arguments "*: :(($(ls ~/.project-templates/)))"
}
compdef _init_project_template_zsh_complete init-project-template
