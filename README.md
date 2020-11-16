![rad-shell logo](./resources/rad-shell-logo.png)

A fantastically feature rich, lightning-fast shell, using
[Zsh](http://www.zsh.org/), [Prezto](https://github.com/sorin-ionescu/prezto),
and [Zgen](https://github.com/tarjoilija/zgen).

Compatible with Oh-My-Zsh and Prezto plugins out of the box.

## Update: Potentially breaking change

rad-shell does not automatically load the `git-taculous` theme by default anymore,
allowing you to customize the theme for your own setup.  After updating, the theme will no
longer be loaded automatically (but will be included as one of the default plugins
upon installation).  To add the standard theme to your ~/.rad-plugins file, run:
```
echo 'brandon-fryslie/rad-plugins git-taculous-theme/git-taculous' >> ~/.rad-plugins
```

## Dependencies

rad-shell was designed on MacOS, which includes all dependencies necessary to
run shell.  On other OSs some may need to be installed.  Dependencies include:

- zsh
- git
- perl (for some plugins)

If you find another dependency, please file a GitHub issue and I will add it
here.

## Installation

Set Zsh as your default shell, if necessary: `chsh -s /bin/zsh`

```sh
curl -o- https://raw.githubusercontent.com/brandon-fryslie/rad-shell/master/install.sh | bash
```

This script:
- Backs up any existing ~/.zshrc!
- Writes a shiny new ~/.zshrc file!
- Writes a ~/.rad-plugins file to keep track of your rad plugins!
- Clones Zgen!
- Clones the plugin repos and configures your new rad shell!

If you want to install rad-shell **without any default plugins**, use this command:

```sh
export SKIP_DEFAULT_PLUGINS=true; curl -o- https://raw.githubusercontent.com/brandon-fryslie/rad-shell/master/install.sh | bash
```

## Usage

### Theme

You can configure the default theme with several environment variables:

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

You can add new plugins to the `.rad-plugins` file.  Check out my dotfiles repo
for an example of how to to do this: https://github.com/brandon-fryslie/dotfiles/blob/master/dotfiles/rad-plugins

Zgen will clone the plugin repos to a local directory.  To pull upstream changes,
run `zgen update`.  Zgen will pull the latest changes in all repos
and then regenerate the init file the next time a shell is opened.

### Commands

`zgen update` - tell zgen to update all of the plugins

### Shortcuts

**Important:** for your meta key (alt/option) to function properly, it must be
set to 'Esc+' in the iTerm settings.

You can set that by running this command **with iTerm closed** (use Terminal):
`/usr/libexec/PlistBuddy -c 'Set :"New Bookmarks":0:"Option Key Sends" 2' ~/Library/Preferences/com.googlecode.iterm2.plist`

#### FilterList commands

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

## Plugins

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

### Zaw & Fasd

Zaw provides a UI to incrementally search lists from multiple sources, similar to
Helm in emacs.

Fasd keeps track of recently accessed directories and files, allowing you to access
it with Zaw.

'Filter search' commands are provided by Zaw

## Caveats

**Important:**  For the time being, you must use my fork of the project which
has an important bugfix with regards to module loading order.  You might see
errors about functions not being defined if using the official Zgen repo.

There is a PR open with the fix that I hope will be merged: https://github.com/tarjoilija/zgen/pull/87

## DEPRECATION WARNING for pre-alpha rad-shell users

If you are a rad-shell user who recently updated and now you are missing plugins,
the plugins were moved into the repo here: https://github.com/brandon-fryslie/rad-plugins.
Please update your plugin configuration file accordingly.

##### ~/.zgen-setup.zsh is DEPRECATED

**If your rad-shell installation is using this file, please follow the instructions below**

Due to a recent major refactoring, I recommend reinstalling rad-shell to get the newest
version of the rad-shell source code.  Simply follow the installation instructions
again, then copy any customizations from your old `~/.zshrc` (which will be renamed to `~/.zshrc.nn.bak` where 'n' is a number) file to the new
`~/.zshrc` file generated during installation.

The new rad-shell will update itself automatically whenever you run `zgen update`,
so you won't need to do this again.  I apologize for the inconvenience.  Thanks for
being an early user of rad-shell and helping to make it better for everyone.
