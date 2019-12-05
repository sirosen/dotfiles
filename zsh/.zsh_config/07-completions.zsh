# globus-cli completer
if type globus > /dev/null; then
    eval "$(globus --zsh-completer)"
fi

# ec2ssh completer
eval "$(_ec2ssh_print_completion --shell zsh)"

#compdef init-project-template
_init_project_template_zsh_complete() {
    _arguments "*: :(($(ls ~/.project-templates/)))"
}
compdef _init_project_template_zsh_complete init-project-template
