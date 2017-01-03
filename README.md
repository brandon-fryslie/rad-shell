# Rad Shell

A fantastically feature rich, lightening-fast shell, using
[Zsh](http://www.zsh.org/), [Prezto](https://github.com/sorin-ionescu/prezto),
and [Zgen](https://github.com/tarjoilija/zgen).

Compatible with Prezto plugins, and many Oh-My-Zsh plugins out of the box.

## Features

The example .zshrc file includes several great plugins by default:

- fasd
  - keep track of useful
  - requires install: `brew install fasd`
- git-taculous theme
  - displays git, node, and docker information in your prompt
- zaw
  - emacs-style incrementally filterable lists
- zsh-autosuggestions
  - show autosuggestions based on command history
- zsh-completions
  - more useful completions
- zsh-nvm
  - automatically install NVM and switch to the correct node version
- zsh-syntax-highlighting
  - syntax highlighting on the command line

## Installation

2 choices:

Run `install.rb`

or

Set your default shell to Zsh, install Zgen manually
using the instructions on the Zgen website and then copy over the `.zshrc.zgen`
file from this repo to `~/.zshrc`.

## Usage

If you change your .zshrc file, you will need to run `zgen reset` so Zgen
can regenerate the static configuration file.

Zgen will clone the plugin repos to a local directory.  To pull upstream changes,
run `zgen update`.  Zgen will pull the latest changes in all repos
and then regenerate the init file the next time a shell is opened.

## Caveats

Directly sourcing your .zshrc file will cause the current shell to exit, for
some unknown reason.  Pull requests for a fix are welcome.  As a workaround,
open a new shell rather than using `source ~/.zshrc`.
