# vim: set ft=sh :
set -x DOTFILES_HOME $HOME/.dotfiles
set -x DOTFILES_HOSTNAME (hostname -s)
set -x DOTFILES_HOST_FISH_CONFIG $DOTFILES_HOME/fish/environments/$DOTFILES_HOSTNAME
set -x DOTFILES_SHELL_CONFIG "$HOME/.config/fish/config.fish"

if test -e $DOTFILES_HOST_FISH_CONFIG
  source $DOTFILES_HOST_FISH_CONFIG
else
  echo "No host specific fish config detected. You can create one at $DOTFILES_HOST_FISH_CONFIG"
end

# Enable vi mode for fish
fish_vi_key_bindings
