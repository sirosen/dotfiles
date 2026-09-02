,cpython-open-rebuild () {
  cd ~/projects/github/python/cpython/
  if [ "$(git status --porcelain 2>&1 | egrep -v '^\?\?')" != "" ]; then
    echo 'git status was not clean'
    return 1
  fi

  NUM="$1"
  BRANCH="pr-rebuild/${NUM}"
  if git rev-parse "$BRANCH" > /dev/null 2>&1; then
    git switch "$BRANCH"
  else
    gh pr checkout "$NUM"
    git switch -c "$BRANCH"
    git rebase main
  fi
}
