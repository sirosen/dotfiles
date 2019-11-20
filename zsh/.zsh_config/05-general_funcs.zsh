# random

set-tmux-title () {
  printf '\033k'"$1"'\033\\'
}

venv-activate() {
    source "$1"/bin/activate
}

forget-known-host () {
    ssh-keygen -f ~/.ssh/known_hosts -R "$1"
}

cwd-fileserver () {
  local port=8000
  [ $# -gt 0 ] && port="$1"
  python3 -m http.server "$port"
}

magick-hostname-background-gnome3 () {
    local image_loc="$HOME/Pictures/autogenbg.png"
    convert -size 1440x900 xc:lightgrey -font Palatino-Bold -pointsize 128 -fill black -draw "text 400,300 '$(hostname)'" -blur 0x1 "$image_loc"
    gsettings set "org.gnome.desktop.background picture-uri" "file:///$image_loc"
    gsettings set "org.gnome.desktop.background picture-options" "stretched"
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

# aws

lookup-instance-id () {
  local iid="$1"
  shift
  aws ec2 describe-instances \
      --query 'Reservations[].Instances[?InstanceId==`'"$iid"'`][] | [0]' \
      "$@"
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
