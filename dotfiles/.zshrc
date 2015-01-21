# Load environment
source $HOME/.dotfiles_env

# ZSH Defaults
source $DOTFILES_HOME/zsh/settings
source $DOTFILES_HOME/zsh/bindkeys
source $DOTFILES_HOME/zsh/libs/git-prompt.sh
source $DOTFILES_HOME/zsh/libs/spectrum.zsh
source $DOTFILES_HOME/zsh/libs/take.sh

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

[[ -s $HOME/.zshrc.local ]] && source $HOME/.zshrc.local
