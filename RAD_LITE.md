# rad-lite

rad-lite is a lightweight way to install rad-shell (or other zsh plugins) plugins without using rad-shell

It is a small bash script that will download the plugins to a local directory.  You can
then source them in your .bashrc/.zshrc file.  Note that many zsh plugins are not directly
compatible with bash.  This solution is simpler but not as robust as using rad-shell directly.

## caveats

There are some important things to note with using this:
- Not all plugins are bash/zsh agnostic.  They all work with zsh, but there may be missing or broken functionality in bash
- There is no dependency management.  If you install a plugin that depends on a different plugin, you need to manage that yourself
- Almost every rad-shell plugin depends on the `init-plugin` in rad-shell.  Ensure it is installed with `rad-lite install https://github.com/brandon-fryslie/rad-shell/blob/master/init-plugin/init-plugin.plugin.zsh`

## installation

Run these commands to install the `rad-lite` shell script.  Feel free to inspect the
contents of the script if you're curious as to how it works or what it will do.

```
curl -o- https://raw.githubusercontent.com/brandon-fryslie/rad-shell/master/bin/rad-lite > /usr/local/bin/rad-lite
chmod +x /usr/local/bin/rad-lite
```

## usage

To use `rad-lite`, first install a plugin, and then add `eval "$(rad-lite init)"` to your .bashrc/.zshrc file.

This will automatically source all plugins that have been installed with `rad-lite`.

If you prefer to source the files in your .bashrc file yourself, you can use `rad-lite list` to print a list of plugin file paths.

**Important:** All rad-shell plugins depend on the `init-plugin`!  Don't forget to install it with `rad-lite install https://github.com/brandon-fryslie/rad-shell/blob/master/init-plugin/init-plugin.plugin.zsh`

### rad-lite install

Use `rad-lite install <plugin url>` to install a plugin.

example:
```
rad-lite install https://github.com/brandon-fryslie/rad-plugins/blob/master/git/git.plugin.zsh
```

### rad-lite init

This command prints a shell script suitable for sourcing all the plugins in your .bashrc/.zshrc file.

example .bashrc:
```
... other bashrc contents ...
eval "$(rad-lite init)"
```

### rad-lite list

Prints a list of all plugin files that have been downloaded by `rad-lite`.

### rad-lite implode

Deletes the plugin files and the `~/.rad-shell-lite` directory.

`rad-lite implode && rm -rf /usr/bin/local/rad-lite` will erase `rad-lite` entirely from your machine.
