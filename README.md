# Rad Shell

![rad-shell logo](./resources/rad-shell-logo.png)

A fantastically feature rich, lightening-fast shell, using
[Zsh](http://www.zsh.org/), [Prezto](https://github.com/sorin-ionescu/prezto),
and [Zgen](https://github.com/tarjoilija/zgen).

Compatible with Prezto plugins, and many Oh-My-Zsh plugins out of the box.

Note: the install script will only work on macOS due to the use of `homebrew`.  
Some of the key bindings may also need to be adjusted for other OS's.

**Important:**  For the time being, you must use my fork of the project which
has an important bugfix with regards to module loading order.  You might see
errors about functions not being defined if using the official Zgen repo.

There is a PR open with the fix that I hope will be merged: https://github.com/tarjoilija/zgen/pull/87

My fork is located here: https://github.com/brandon-fryslie/zgen

## Features

The example .zshrc file includes several great plugins by default:

- fasd
  - keep track of recent files / directories
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

## Installation & Usage

Set Zsh as your default shell, if necessary: `chsh -s /bin/zsh`


2 choices:

1.  Clone this repo, then run `install.rb`

or

1.  Install (forked) Zgen: `git clone https://github.com/brandon-fryslie/zgen "${HOME}/.zgen"`
1.  Install Fasd if desired (substitute your own package manager if not on macOS): `brew install fasd`
  - Fasd keeps track of recently used files and directories.  Related Functionality won't work without Fasd
1.  Copy the contents of `.zshrc.zgen` and `.zgen-setup.zsh` from this repo to `~/.zshrc` and `~/.zgen-setup.zsh`
1.  Copy your own customizations into ~/.zshrc if desired

That's it!

### install.rb

You can use `install.rb` to install Zgen and the default .zshrc and .zgen-setup.zsh files

You can run `install.rb --clean` to remove back up your existing .zshrc and .zgen-setup.zsh
files, remove Zgen, and uninstall `fasd`

### Theme

You can configure the theme with several environment variables:

`ENABLE_DOCKER_PROMPT=true`
- set this to show your DOCKER_HOST in the prompt

`LAZY_NODE_PROMPT=true`
- show nodejs and npm versions in your prompt
- will only show versions once NVM has been sourced
- you must use the nvm-lazy-load plugin in this repo for this to work

`ENABLE_NODE_PROMPT=true`
- show nodejs and npm versions in your prompt
- this will load NVM right away, adding significant time to your shell's startup time

### Zgen

You can add new plugins to the `.zgen-setup.zsh` file.  Check out the plugins
in this repo for an example of how to add a new plugin to your `.zgen-setup.zsh`
file from a github repo.

If you change your `.zgen-setup` file, you will need to run `zgen reset` so Zgen
can regenerate the static configuration file for your plugins.

Zgen will clone the plugin repos to a local directory.  To pull upstream changes,
run `zgen update`.  Zgen will pull the latest changes in all repos
and then regenerate the init file the next time a shell is opened.

## Commands

`zgen update` - tell zgen to update all of the plugins

## Shortcuts

**Important:** for your meta key (alt/option) to function properly, it must be
set to 'Esc+' in the iTerm settings.

You can set that by running this command **with iTerm closed** (use Terminal):
`/usr/libexec/PlistBuddy -c 'Set :"New Bookmarks":0:"Option Key Sends" 2' ~/Library/Preferences/com.googlecode.iterm2.plist`

### Filter search commands

These commands will display a filterable list that you can choose from.

When in the menu:

Press `enter` to execute the **primary action**
Press `meta + enter` to execute the **secondary action**
Press `tab` to access the list of possible actions

`Ctrl+R, Ctrl+R` - Search command history

Primary action: execute command

Secondary action: replace buffer with command

`Meta+Shift+D` - Search recent directories

Action: insert into buffer

`Meta+Shift+F` - Search recent files

Action: insert into buffer

`Meta+Shift+B` - Search git branches

Action: checkout branch

`Meta+Shift+O` - Search files tracked by git.  Shows git status of files

Primary action: Edit file

Secondary action: Execute 'git add' on file

`Meta+Shift+L` - Search git log

Primary action: Insert SHA of selected commit

Secondary action: Execute 'git reset'

`Meta+Shift+R` - Search git reflog

Primary action: Insert SHA of selected commit

Secondary action: Execute 'git reset'

`Meta+Shift+S` - Show git status

Primary action: Execute 'git add' on selected file

Secondary action: Execute 'git add -p' on selected file.  -p (patch) allows adding
specific hunks to the commit

`Meta+Shift+S` - Show Zaw menu

The Zaw menu will give you access to all sources

## Features

### Zaw & Fasd

Zaw provides a UI to incrementally search lists from multiple sources, similar to
Helm in emacs.

Fasd keeps track of recently accessed directories and files, allowing you to access
it with Zaw.

'Filter search' commands are provided by Zaw


## Caveats

Directly sourcing your .zshrc file will cause the current shell to exit, for
some unknown reason.  Pull requests for a fix are welcome.  As a workaround,
open a new shell rather than using `source ~/.zshrc`.
