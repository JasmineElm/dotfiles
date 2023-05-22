#!/usr/bin/env bash

readonly THIS_SCRIPT=$0


list_files() {
  find . -type f \
    -not -path "./.git*" \
    -not -path "$THIS_SCRIPT"
}


select_branch() {
# work out environment from uname -a
    local branch
    unm=$(uname -a)
    if [[ $unm == *"Microsoft"* ]]; then
        branch="wsl"
    elif [[ $unm == *"Darwin"* ]]; then
        branch="darwin"
    elif [[ $unm == *"Android"* ]]; then
        branch="android"
    elif [[ $unm == *"Linux"* ]]; then
        branch="linux"
    else
        branch="unknown" && exit 1
    fi
    git checkout "$branch"
}

clean() {
  # remove swap files, empty directories, and backup files
  find . -type f -name "*.swp" -delete
  find . -type d -empty -delete
  find . -type f -name "*~" -delete
}

update() {
  clean
  for f in $(list_files); do
    # strip the leading ./
    f=${f#./}
    rsync -a "$HOME/$f" "$f"
  done
}

datestamp() {
  # add a datestamp
  date +"%Y-%m-%d %H:%M"
}

pushit() {
  git pull
  git add .
  git commit -q -m "sync: $(datestamp)"
  git push
}

add_and_push() {
  # update, and push any changes
  update
  select_branch
  out_of_sync=$(git status --porcelain | wc -l)
  [ "$out_of_sync" -eq 0 ] || pushit
}

_main() {
    if [[ -z "$*" ]]
        then add_and_push;
    fi
    while getopts ":u" opt; do
        case $opt in
            u)
              update
            ;;
            *)
              add_and_push
            ;;
        esac
    done
}

_main "$@"
