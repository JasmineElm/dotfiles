<<<<<<< HEAD
# My Dotfiles                                                                                                                  
=======
# My Dotfiles
>>>>>>> a7cbf5c (sync: 2023-05-24 22:29)

I use \*nix in a varietyof environments. I have traditionally written
config that covers all of these, using conditions to add local
functionality where needed (e.g., using gnu flags in Linux, and BSD in
macos). Whilst this seems to work, it results in a lot of redundant or
confusing config. In an attempt to remediate this, I have segregated the
repo by environment; each branch should only contain the config relevant
to a specific enviroment.

It's still early days of using this approach, so I may decide to go back
to a monolithic config base, but logically, this should be more
maintainable moving forward.

## Using this repo for your own config.

There are two approaches. Its up to you which one suits.

1.  checkout the "closest" branch. If you're using Linux, you could
<<<<<<< HEAD
    checkout the `linux` branch and `./updateRepo -i` (install) . You'll get my
    config as a base to work from.  
2.  checkout `main` and work from a clean slate. If you want to avoid my
    config (and you should!) checkout main, add your dotfiles, change the
    `_MAIN_ONLY` flag in the script, and `./updateRepo -r` to sync your changes
=======
    checkout the `linux` branch and `./updateRepo -i` (install) . You'll
    get my config as a base to work from.
2.  checkout `main` and work from a clean slate. If you want to avoid my
    config (and you should!) checkout main, add your dotfiles, change
    the `_MAIN_ONLY` flag in the script, and `./updateRepo -r` to sync
    your changes
>>>>>>> a7cbf5c (sync: 2023-05-24 22:29)

In either case, you'll want to `rm .git* && git init` to get your config
tracking a repo of your own, but you already knew that didn't you ;)
