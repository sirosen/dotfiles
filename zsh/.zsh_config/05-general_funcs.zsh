# random

set-tmux-title () {
  tmux rename-window "$1"
}

venv-activate() {
    source "$1"/bin/activate
}

forget-known-host () {
    ssh-keygen -f ~/.ssh/known_hosts -R "$1"
}

show-ansi-colors () {
  echo -e '\\e[39m...\\e[0m: '"\e[39mDefault\e[0m"
  echo -e '\\e[30m...\\e[0m: '"\e[30mBlack\e[0m"
  echo -e '\\e[31m...\\e[0m: '"\e[31mRed\e[0m"
  echo -e '\\e[32m...\\e[0m: '"\e[32mGreen\e[0m"
  echo -e '\\e[33m...\\e[0m: '"\e[33mYellow\e[0m"
  echo -e '\\e[34m...\\e[0m: '"\e[34mBlue\e[0m"
  echo -e '\\e[35m...\\e[0m: '"\e[35mMagenta\e[0m"
  echo -e '\\e[36m...\\e[0m: '"\e[36mCyan\e[0m"
  echo -e '\\e[37m...\\e[0m: '"\e[37mLight gray\e[0m"
  echo -e '\\e[90m...\\e[0m: '"\e[90mDark gray\e[0m"
  echo -e '\\e[91m...\\e[0m: '"\e[91mLight red\e[0m"
  echo -e '\\e[92m...\\e[0m: '"\e[92mLight green\e[0m"
  echo -e '\\e[93m...\\e[0m: '"\e[93mLight yellow\e[0m"
  echo -e '\\e[94m...\\e[0m: '"\e[94mLight blue\e[0m"
  echo -e '\\e[95m...\\e[0m: '"\e[95mLight magenta\e[0m"
  echo -e '\\e[96m...\\e[0m: '"\e[96mLight cyan\e[0m"
  echo -e '\\e[97m...\\e[0m: '"\e[97mWhite\e[0m"
  echo -e '\\e[1;31m...\\e[0m: '"\e[1;31mBold Red\e[0m"
  echo -e '\\e[1;33m...\\e[0m: '"\e[1;33mBold Yellow\e[0m"
}

magick-hostname-background-gnome3 () {
    local image_loc="$HOME/Pictures/autogenbg.png"
    convert -size 1440x900 xc:lightgrey -font Palatino-Bold -pointsize 128 -fill black -draw "text 400,300 '$(hostname)'" -blur 0x1 "$image_loc"
    gsettings set "org.gnome.desktop.background picture-uri" "file:///$image_loc"
    gsettings set "org.gnome.desktop.background picture-options" "stretched"
}

init-project-template () {
  templatedir="$1"
  if [ ! -d ~/.project-templates/$1 ]; then
      echo "error: nonexistent project template $1"
      return 1
  elif [ "$(ls -A)" != "" ]; then
      echo "conflict: cwd must be empty"
      return 1
  fi
  cp ~/.project-templates/$1/* .
}

# git

github-clone () {
    git clone git@github.com:"${1}".git "${@:2}"
}

globus-clone () {
    github-clone globusonline/"$1" "${@:2}"
}

remote-push () {
    br=$(git rev-parse --abbrev-ref HEAD)
    r="origin"
    if [ $# -gt 0 ];
    then
        r="$1"
    fi
    git push -u "$r" "$br"
}

git-merge-base-diff () {
    git diff "$(git merge-base HEAD "$1")"
}

git-sync-remote () {
  if [ ! -d .git ]; then
    echo "didn't find .git/"
    return 1
  fi
  remote="$1"

  git fetch "$remote" --prune

  for branch in $(find .git/refs/heads -type f | cut -d '/' -f4-); do
    echo "update remote branch $branch"
    git push -q "$remote" "$branch"
  done

  for remotebranch in $(find .git/refs/remotes/$remote -type f | cut -d '/' -f5-); do
    if [ ! -f ".git/refs/heads/$remotebranch" ]; then
      echo "delete remote branch $remotebranch"
      git push -q --delete "$remote" "$remotebranch"
    fi
  done
}

git-setup-precommit-cmd () {
  if [ ! -d .git ]; then
    echo "didn't find .git/"
    return 1
  fi
  cmd="$1"
  cat > .git/hooks/pre-commit <<EOH
#!/bin/sh
# go to repo root
cd "\$(dirname "\$0")/../.." || exit 1
# Redirect output to stderr.
exec 1>&2
# run command
${cmd}
EOH
  chmod u+x .git/hooks/pre-commit
}

git-equivalent-in-master () {
  if ! git status --porcelain > /dev/null; then
    echo "working tree not clean"
    return 2
  fi
  target="$1"
  git checkout --quiet master~0
  git merge --quiet --no-commit "$1"
  echo "------"
  if git diff --quiet master; then
    echo "\e[92m$1 or an equivalent changeset was merged to master\e[0m"
  else
    echo "\e[91m$1 was not merged to master\e[0m"
  fi
  git reset --hard master  # discard
  git checkout --quiet master  # go to master branch
}

# aws

ec2-lookup-instance-id () {
  local iid="$1"
  shift
  aws ec2 describe-instances \
      --query 'Reservations[].Instances[?InstanceId==`'"$iid"'`][] | [0]' \
      "$@"
}

ec2-instance-by-name () {
  local iname="$1"
  shift 1
  aws ec2 describe-instances \
      --filters "Name=tag:Name,Values=$iname" "$@"
}

ec2-terminate-instance-by-name () {
  local iname="$1"
  shift 1
  local iid
  iid="$(aws ec2 describe-instances \
      --filters "Name=tag:Name,Values=$iname" "Name=instance-state-name,Values=running" \
      --query "Reservations[].Instances[].InstanceId" --output text)"

  read -q "confirm?terminate $iname ($iid)? [y/n] "
  echo
  case "$confirm" in
    yes|Yes|y|Y)
      echo "okay, terminating..."
      aws ec2 terminate-instances --instance-ids "$iid"
      ;;
    no|No|n|N)
      ;;
    *)
      echo "unrecognized answer; treated as N"
      ;;
  esac
}

# ssh

unload-ssh-keys () {
    pkill ssh-agent
}
load-ssh-keys () {
    if [ ! -S "$SSH_AUTH_SOCK" ]; then
        ssh-agent -a "$SSH_AUTH_SOCK" > /dev/null
        ssh-add ~/.ssh/id_rsa
        ssh-add ~/.ssh/globus_rsa
    fi
}

# gpg

load-gpg-key () {
    t="$(mktemp)"
    touch "$t"
    gpg -s "$t"
    rm -f "$t" "${t}.gpg"
}

# installs

vundle-setup () {
    git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle 2&>/dev/null
    (cd ~/.vim/bundle/vundle && git pull 2&>1 >/dev/null)
    vim +PluginInstall +qall
}

# my custom vim config, read by autoload func in vimrc
myvim-config-generate () {
  echo "writing to ${PWD}/.myvim-config"
  cat > .myvim-config <<EOH
autoformat = off
py_isort = off
py_ruff = on
EOH
}
