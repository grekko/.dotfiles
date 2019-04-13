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

# Add .scripts to PATH
set -x PATH ~/.scripts $PATH

# Load shell aliases
source "$HOME/.shell_aliases"
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/libxml2/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/gettext/bin" $fish_user_paths
