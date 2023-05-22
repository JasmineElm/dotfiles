#!/usr/bin/env bash

<<<<<<< HEAD
###  DEBUG          ###########################################################
# set -u -e -o errtrace -o pipefail
#trap "echo ""errexit: line $LINENO. Exit code: $?"" >&2" ERR
IFS=$'\n\t'

###  VARIABLES      ###########################################################
_MAIN_ONLY=0        ## set to 1 if you dont want a branch for each OS

readonly THIS_SCRIPT=$0
_FULL_PATH="$(realpath "${0}")"
_PATH=${_FULL_PATH%/*}
_FULL_FN=${_FULL_PATH##*/}
_EXT=${_FULL_FN##*.}
_FN=${_FULL_FN%.*}

## Colours

_bld=$(tput bold)
_nrm=$(tput sgr0)

###  FUNCTIONS      ###########################################################

is_main_only() {
  # check if we're running in main only mode
  [[ $_MAIN_ONLY -eq 1 ]]
}


print_help() {
  cat <<HEREDOC

Update dotfiles repo by copying relevant files from '$HOME'.
To manually add files, manually copy them to the repo
ensuring that their repo path matches the relative path  from '$HOME'
  e.g., '$HOME/.vim/vimrc' should be copied to '.vim/vimrc' in the repo.

By default, this script will create a branch for each OS
and push changes to that branch.
If you want to run this script without creating a branch,
use the $_bld"_IS_MAIN_ONLY"$_nrm variable.


Usage:
  ${_FULL_FN} [<arguments>]

Options:
  $_bld-h$_nrm    Show this screen.
  $_bld-l$_nrm    update local repo from $HOME
  $_bld-r$_nrm    update remote repo after updating local repo

HEREDOC
}
### FUNCTIONS      ############################################################

datestamp() {
  # add a datestamp to the commit message
  date +"%Y-%m-%d %H:%M"
}

## List and update local files

list_files() {
  # list all files in the local repo that we'd want to update
  find . -type f \
    -not -path "./.git*" \
    -not -path "$THIS_SCRIPT" \
    -not -path ".swp"
}

clean() {
  # remove empty, swap and backup files
  find . -type f -iname "*.swp" -delete
  find . -empty -delete
  find . -type f -iname "*~" -delete
}

delete_if_not_exists() {
  # delete a file if it doesn't exist in the path
  local f="$1"
  local path="$2"
  [[ ! -f $path$f ]] && rm "$f"
}

update_local() {
  # use rsync to copy files from $HOME to this repo
  #
  for f in $(list_files); do
    # strip the leading ./
    f=${f#./}
    rsync -a "$HOME/$f" "$f" 2>/dev/null || true
    delete_if_not_exists "$f" "$HOME/"
  done
  clean
}

## Branch management
select_branch() {
  local branch
  unm=$(uname -a)
  if [[ $unm == *"Microsoft"* ]]; then
    branch="wsl"
  elif [[ $unm == *"Darwin"* ]]; then
    branch="macos"
  elif [[ $unm == *"Android"* ]]; then
    branch="android"
  elif [[ $unm == *"Linux"* ]]; then
    branch="linux"
  else
    branch="unknown" && exit 1
  fi
  echo "$branch"
}

branch_exists() {
  # check if branch exists
  local branch="$1"
  git rev-parse --verify "$branch" >/dev/null 2>&1 | wc -l
}

switch_branch() {
  if [[ $(is_main_only) -eq 1 ]]; then
    git checkout main
    return
  else
    if [[ -z "$branch" ]]; then
      echo "No branch specified"
      exit 1
    elif [[ $(branch_exists "$branch") -eq 0 ]]; then
      git checkout "$branch"
    else
      git checkout -b "$branch"
    fi
  fi
=======
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
>>>>>>> main
}

pushit() {
  git pull
  git add .
  git commit -q -m "sync: $(datestamp)"
<<<<<<< HEAD
  git push -u origin "$(git rev-parse --abbrev-ref HEAD)"
}

update_remote() {
  # update, and push any changes
  branch=$(select_branch)
  switch_branch "$branch"
  update_local
=======
  git push
}

add_and_push() {
  # update, and push any changes
  update
  select_branch
>>>>>>> main
  out_of_sync=$(git status --porcelain | wc -l)
  [ "$out_of_sync" -eq 0 ] || pushit
}

_main() {
<<<<<<< HEAD
  if [[ -z "$*" ]]; then
    print_help
    exit 1
  fi
  while getopts ":lrh" opt; do
    case $opt in
    l)
      update_local
      ;;
    r)
      update_remote
      ;;
    h)
      print_help
      ;;
    *)
      echo "$_bld"ERROR: Invalid option: -"$OPTARG $_nrm"
      print_help
      exit 1
      ;;  # unknown option
    esac
  done
=======
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
>>>>>>> main
}

_main "$@"
