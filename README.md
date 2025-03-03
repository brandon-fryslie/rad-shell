![rad-shell logo](./resources/rad-shell-logo.png)

A fantastically feature rich, lightning-fast shell, using
[Zsh](http://www.zsh.org/), [Prezto](https://github.com/sorin-ionescu/prezto),
and [Zgen](https://github.com/tarjoilija/zgen).

Compatible with Oh-My-Zsh and Prezto plugins out of the box.

## Dependencies

The only hard dependencies are:
- zsh
- git

Some plugins depend on:
- perl

If you find another dependency, please file a GitHub issue and I will add it
here.

## Installation / Uninstallation

Set Zsh as your default shell, if necessary: `chsh -s /bin/zsh`

### Install with default plugins (quickstart)

```sh
curl -o- https://raw.githubusercontent.com/brandon-fryslie/rad-shell/master/install.sh | bash
```

This script:
- Backs up any existing ~/.zshrc
- Writes a shiny new ~/.zshrc file
- Writes a ~/.rad-plugins file to keep track of your rad plugins
- Configures Zgen
- Automatically initializes plugins

### Install without default plugins

If you want to install rad-shell **without any default plugins**, use this command:

```sh
export SKIP_DEFAULT_PLUGINS=true; curl -o- https://raw.githubusercontent.com/brandon-fryslie/rad-shell/master/install.sh | bash
```

### Existing oh-my-zsh (or other zsh) installation

If you're already using zsh or oh-my-zsh, follow these steps: 

- Run standard installation instructions
- Copy any functions, environment variables, or other customizations from your old ~/.zshrc file (rad-shell creates a backup on install)
  - Do not copy oh-my-zsh plugins (e.g., the `plugins=(...)` list) or other code to load zsh plugins.  rad-shell handles this via the `~/.rad-plugins` file
- Add any zsh plugins you want to load to ~/.rad-plugins
  - You can load plugins from any `git` repo
  - For example, to load a `oh-my-zsh` plugin add this to your ~/.rad-plugins file: `ohmyzsh/ohmyzsh plugins/kubectx`
  - Any change to the ``
- You can add any zsh plugins from any git repo, not only oh-my-zsh

Note: `rad-shell` replaces some basic `oh-my-zsh` plugins with `prezto`.  `prezto` is optimized for speed.  You can still load
any standard `oh-my-zsh` plugins, but `rad-shell` automatically loads the base functionality required for other plugins to 
work correctly.

The base plugins loaded are: `environment terminal editor history directory spectrum utility completion prompt`

### Restore your old shell configuration

If you decide you don't want to use `rad-shell`, simply replace your ~/.zshrc file with the backup made during `rad-shell`
installation.

### Adding/removing plugins

Plugins are added or removed by modifying the `~/.rad-plugins` file.  Any change to this file will cause the plugins to
reinitialized when a new terminal window is opened or by running `source ~/.zshrc`.

Plugins in the file follow this format:
```
# The generalized format is this:
github-repo-or-org/repo-name path/to/zsh/plugin

# Load a standard oh-my-zsh plugin
# Translates to url: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/docker
ohmyzsh/ohmyzsh plugins/docker

# Custom plugins in root directory
# Tranlates to url: https://github.com/brandon-fryslie/rad-plugins/tree/master/docker
brandon-fryslie/rad-plugins docker
```

The lines in this file are passed directly to `zgen load`.  Anything supported by the `zgen load` command is supported 
here.  This means you can load plugins from any `git` url, including non-public sources (e.g., internal GitHub Enterprise).

Docs: https://github.com/tarjoilija/zgen#load-plugins-and-completions

### Update plugins

To update your plugins, run `zgen update`.  `zgen` handles updating all plugin repos via git.

### Removing `rad-shell`

If you want to remove `rad-shell` entirely, remove the following files/directories:

- `rm -rf ~/.rad-plugins ~/.rad-shell ~/.zgen`
  - This removes all `rad-shell` and `zgen` files
- `mv ~/.zshrc ~/.zshrc.rad-shell.bak`
  - Back up the `~/.zshrc` file so you can grab any customizations later
- `cp /path/to/backup/zshrc ~/.zshrc`
  - Use this if you have an existing `.zshrc` file you want to restore
- `touch ~/.zshrc`
  - Use this if you want to create an empty `~/.zshrc` file and start from scratch

Removing the `rad-shell` and `zgen` files is not necessary to stop using `rad-shell`.  Removing or commenting out the line
`source $HOME/.rad-shell/rad-init.zsh` in your ~/.zshrc file will accomplish this.

## Running Tests

To run the tests for the rad-shell scripts, you need to have [ShellSpec](https://github.com/shellspec/shellspec) installed. Once installed, you can execute the tests by navigating to the directory containing the test files and running:

```sh
shellspec
```

This command will execute all the test files with the `.bats` extension in the `tests` directory and display the results in your terminal.

Ensure that each test file is properly set up to source the script it is testing and contains the necessary test cases.

## Usage

Note: most of this functionality comes from the rad-shell plugins repo: https://github.com/brandon-fryslie/rad-plugins

### Theme

#### default theme: `git-taculous`

This is the standard theme included with rad-shell.  It can be disabled by
removing the line `brandon-fryslie/rad-plugins git-taculous-theme/git-taculous`
from your `~/.rad-plugins` file.

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

#### other themes

You can use other themes that are compatible with oh-my-zsh.  Here are some: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

To use one of those, add it to your ~/.rad-plugins file the same as any other plugin.

Most oh-my-zsh themes work correctly, but not all of them do for whatever reason.  This is a bug (or bugs)
and might get fixed some day.  We most likely just need to include more `libs` from the `oh-my-zsh` repo.

### Zgen

You can add new plugins to the `~/.rad-plugins` file.  Check out my dotfiles repo
for an example of how to do this: https://github.com/brandon-fryslie/dotfiles/blob/master/dotfiles/rad-plugins

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
