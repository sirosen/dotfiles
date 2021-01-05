for x in ~/.zsh_config/*.zsh; do
  source "$x"
done

export PATH="$HOME/.poetry/bin:$PATH"
