# ZSH Defaults
source $DOTFILES_HOME/zsh/aliases
source $DOTFILES_HOME/zsh/bindkeys
source $DOTFILES_HOME/zsh/helper

export DOTFILES_CONFIG_PATH="$DOTFILES_HOME/zsh/configs/`hostname -s`"
export DOTFILES_PRIVATE_CONFIG_PATH="$DOTFILES_CONFIG_PATH.local"

if [[ -s $DOTFILES_CONFIG_PATH ]] ; then
  source $DOTFILES_CONFIG_PATH
else
  echo "Create a config to customize your shell: $DOTFILES_CONFIG_PATH » Currently running in default mode. You can also create a local file with private settings: $DOTFILES_PRIVATE_CONFIG_PATH"
fi

if [[ -s $DOTFILES_PRIVATE_CONFIG_PATH ]] ; then
  source $DOTFILES_PRIVATE_CONFIG_PATH
fi
