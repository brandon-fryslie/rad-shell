# Rad Shell

A fantastically feature rich, lightening-fast shell, using
[Zsh](http://www.zsh.org/), [Prezto](https://github.com/sorin-ionescu/prezto),
and [Zgen](https://github.com/tarjoilija/zgen).

Compatible with Prezto plugins, and many Oh-My-Zsh plugins out of the box.

Note: the install script will only work on macOS due to the use of `homebrew`.  
Some of the key bindings may also need to be adjusted for other OS's.

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

Set Zsh as your default shell, if necessary: `chsh -s /bin/zsh`


2 choices:

1.  Clone this repo, then run `install.rb`

or

1.  Install Zgen: `git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"`
1.  Install Fasd if desired (substitute your own package manager if not on macOS): `brew install fasd`
1.  Copy the contents of `.zshrc.zgen` and `.zgen-setup.zsh` from this repo to `~/.zshrc` and `~/.zgen-setup.zsh`

That's it!

## Usage

### install.rb

You can use `install.rb` to install Zgen and the default .zshrc and .zgen-setup.zsh files

You can run `install.rb --clean` to remove back up your existing .zshrc and .zgen-setup.zsh
files, remove Zgen, and uninstall `fasd`

### Zgen

You can add new plugins to the `.zgen-setup.zsh` file.  Check out the plugins
in this repo for an example of how to add a new plugin to your `.zgen-setup.zsh`
file from a github repo.

If you change your `.zgen-setup` file, you will need to run `zgen reset` so Zgen
can regenerate the static configuration file for your plugins.

Zgen will clone the plugin repos to a local directory.  To pull upstream changes,
run `zgen update`.  Zgen will pull the latest changes in all repos
and then regenerate the init file the next time a shell is opened.

## Caveats

Directly sourcing your .zshrc file will cause the current shell to exit, for
some unknown reason.  Pull requests for a fix are welcome.  As a workaround,
open a new shell rather than using `source ~/.zshrc`.
