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
git submodule deinit -f -- dotdirs/.vim/bundle/<plugin-name.git>
rm -rf .git/modules/dotdirs/.vim/bundle/<plugin-name.git>
git rm -f dotdirs/.vim/bundle/<plugin-name.git>
```