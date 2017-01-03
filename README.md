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

Run `install.rb`, or set your default shell to Zsh, and install Zgen manually
using the instructions on the Zgen website.  Then copy over the `.zshrc.example`
file to `~/.zshrc`.

## Usage

If you change your .zshrc file, you will need to run `zgen reset` so Zgen
can regenerate the static configuration file.
