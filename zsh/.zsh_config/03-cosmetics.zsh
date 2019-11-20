# colorizing
eval $(dircolors ~/.zsh_config/gruvbox_dircolors)
autoload -U colors && colors

# set prompts
setopt prompt_subst

_color_text () {
  local text
  text="$1"
  shift 1
  echo -n "%{"
  while [ $# -gt 0 ]; do
    case "$1" in
      "--bold")
        hextc "bold"
        ;;
      "--fg")
        shift 1
        hextc "$(~/bin/hextc.sh/gruvbox/dark_colorname.sh "$1")"
        ;;
      "--bg")
        shift 1
        hextc "$(~/bin/hextc.sh/gruvbox/dark_colorname.sh "$1")" --bg
        ;;
    esac
    shift 1
  done
  echo -n "%}"
  echo -n "$text"
  echo -n "%{"
  hextc "reset"
  echo -n "%}"
}

# part of the prompt is exit code when nonzero
exit_code_prompt() {
  local rc=$?
  if [ $rc -ne 0 ]; then
    _color_text " $rc " --bold --bg red --fg bg0_h
  fi
}

precmd () {
    local ecodeprompt="$(exit_code_prompt)"
    local wd="${(%):-%~}"  # working directory

    if [ "${#wd}" -gt 30 ];
    then
        wd="$(rev <<< "$wd" | cut -d '/' -f-3 | rev)"
        wd="$(_color_text " .../" --bg bg2 --fg brightyellow)$(_color_text "$wd " --bg bg2 --fg yellow --bold)"
    else
        wd="$(_color_text " $wd " --bg bg2 --fg yellow --bold)"
    fi

    if [ -n "$ecodeprompt" ]; then
        ecodeprompt="${ecodeprompt}"$'\n'
    fi

    PROMPT="$(_color_text " %* " --bg bg1 --fg fg4)"
    PROMPT="${PROMPT}$wd"

    local current_branch
    current_branch="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
    if [ -n "$current_branch" ]; then
        PROMPT="$(_color_text "ᚠ ${current_branch} " --bold --fg bg1 --bg brightaqua)${PROMPT}"
    fi

    if [ -n "$VIRTUAL_ENV" ]; then
        PROMPT="$(_color_text "virtualenv=$VIRTUAL_ENV" --fg grey --bg bg0_h)"$'\n'"${PROMPT}"
    fi

    PROMPT="${ecodeprompt}${PROMPT} \$ "
    export PS1="$PROMPT"
}

