# plugin-sets (WIP)

This directory contains some of the default "plugin sets" used during rad-shell install.  The install script will 
use the chosen plugin set based upon user input.

## plugins

TODO: list of plugins

## the original

This is the one I use to this day, except for some work plugins in a private GitHub instance.

It's minimal but robust, and includes a very nice git-taculous theme that shows your git status (commit, branch, whether you have staged 
or unstaged changes, remote configuration, whether you're ahead or behind your remote, number of stashes).  It's also easy to
extend (e.g., add docker host, kubectx, node version, venv info, anything you want).

This also includes some personal shell customizations, like improved colors, ZSH highlighting patterns, and improved 
history configuration.  If you're already an expert at configuring ZSH history, you probably have your own config in your
own plugin.  In that case, choose 'the minimal', or 'empty'.

## the minimal

The 'minimal' includes only a few:
- brandon-fryslie/git-taculous theme
- brandon-fryslie/shell-tools

## empty

If you just like the idea of having a plugin manager but don't want any by default plugins, choose this one.

We'll add a commented out example to help you get started.
