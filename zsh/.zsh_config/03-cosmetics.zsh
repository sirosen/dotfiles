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
        hextc "$(~/.hextc/gruvbox/dark_colorname.sh "$1")"
        ;;
      "--bg")
        shift 1
        hextc "$(~/.hextc/gruvbox/dark_colorname.sh "$1")" --bg
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

_prelineadd () {
  local preline="$1"
  local add="$2"
  shift 2

  local sep="|"
  sep="$(_color_text "$sep" --fg fg4 --bg bg0_s)"
  [ -n "$preline" ] && preline="$preline$sep"

  preline="${preline}$(_color_text " $add " --bg bg0_s "$@")"
  echo "$preline"
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

    if [ -n "$VIRTUAL_ENV" ] || [ -n "$GLOBUS_PROFILE" ] || [ -n "$AWS_PROFILE" ] || [ -n "$GLOBUS_SDK_ENVIRONMENT" ]; then
        local pre_line=""
        if [ -n "$AWS_PROFILE" ]; then
          pre_line="$(_prelineadd "$pre_line" "aws:$AWS_PROFILE" --fg orange --bold)"
        fi
        if [ -n "$VIRTUAL_ENV" ]; then
          pre_line="$(_prelineadd "$pre_line" "venv:$VIRTUAL_ENV" --fg yellow)"
        fi
        if [ -n "$GLOBUS_SDK_ENVIRONMENT" ]; then
          pre_line="$(_prelineadd "$pre_line" "sdkenv:$GLOBUS_SDK_ENVIRONMENT" --fg aqua --bold)"
        fi
        if [ -n "$GLOBUS_PROFILE" ]; then
          pre_line="$(_prelineadd "$pre_line" "globus-cli:$GLOBUS_PROFILE" --fg purple --bold)"
        fi
        PROMPT="$pre_line"$'\n'"${PROMPT}"
    fi

    PROMPT="${ecodeprompt}${PROMPT} \$ "
    PS1="$PROMPT"
}

