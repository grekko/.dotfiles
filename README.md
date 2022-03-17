# Docs for Dotfiles

## ViM

Plugin Installation and Version Management is done via git submodules.
Plugins are loaded via tpope's [vim-pathogen](https://github.com/tpope/vim-pathogen).

### Installing a Plugin

```sh
cd ~/.dotfiles
git submodule add <url-to-plugin.git> dotdirs/.vim/bundle/<plugin-name.git>
```

### Uninstall a Plugin

```sh
set PLUGIN_NAME "plugin.git"
git submodule deinit -f -- dotdirs/.vim/bundle/${PLUGIN_NAME}
rm -rf .git/modules/dotdirs/.vim/bundle/${PLUGIN_NAME}
git rm -f dotdirs/.vim/bundle/${PLUGIN_NAME}
```

### Updating plugins

```sh
cd ~/.dotfiles
git submodule update --recursive --remote
```
