# globus-cli completer
if type globus > /dev/null; then
    eval "$(globus --zsh-completer)"
fi

# ec2ssh completer
eval "$(_ec2ssh_print_completion --shell zsh)"
