# ZSH Defaults
source $DOTFILES_HOME/zsh/bindkeys

# ZSH ENV Vars
export DOTFILES_HOSTNAME=`hostname -s`
export DOTFILES_ZSH_CONFIG_PATH="$DOTFILES_HOME/zsh/configs/$DOTFILES_HOSTNAME"
export DOTFILES_ZSH_PRIVATE_CONFIG_PATH="$DOTFILES_ZSH_CONFIG_PATH.local"

if [[ -s $DOTFILES_ZSH_CONFIG_PATH ]] ; then
  source $DOTFILES_ZSH_CONFIG_PATH
else
  echo "Create a config to customize your shell: $DOTFILES_ZSH_CONFIG_PATH » Currently running in default mode. You can also create a local file with private settings: $DOTFILES_ZSH_PRIVATE_CONFIG_PATH"
fi

if [[ -s $DOTFILES_ZSH_PRIVATE_CONFIG_PATH ]] ; then
  source $DOTFILES_ZSH_PRIVATE_CONFIG_PATH
fi

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
