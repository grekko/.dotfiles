# vim: set ft=sh :
set -x DOTFILES_HOME $HOME/.dotfiles
set -x DOTFILES_HOSTNAME (hostname -s)
set -x DOTFILES_ENV_PATH $DOTFILES_HOME/fish/environments/$DOTFILES_HOSTNAME

if test -e $DOTFILES_ENV_PATH
  source $DOTFILES_ENV_PATH
end

function up!
  pushd
  cd $DOTFILES_HOME
  git stash
  git pull origin master
  git stash pop
  # Initialize git submodules which may have been added
  git submodule init
  git submodule update
  popd
  . ~/.config/fish/config.fish
end

# Enable vi mode for fish
fish_vi_key_bindings
