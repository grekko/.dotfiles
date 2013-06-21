source $DOTFILES_HOME/zsh/lib/git.zsh
source $DOTFILES_HOME/zsh/lib/rvm.zsh
source $DOTFILES_HOME/zsh/lib/spectrum.zsh
source $DOTFILES_HOME/zsh/lib/theme-and-appearance.zsh

source $DOTFILES_HOME/zsh/aliases
source $DOTFILES_HOME/zsh/bindkeys

export DOTFILES_CONFIG="$DOTFILES_HOME/zsh/configs/`hostname -s`"
export DOTFILES_LOCAL_CONFIG="$DOTFILES_CONFIG.local"

if [[ -s $DOTFILES_CONFIG ]] ; then
  source $DOTFILES_CONFIG
else
  echo "Create a config to customize your shell: $DOTFILES_CONFIG » Currently running in default mode. You can also create a local file with private settings: $DOTFILES_LOCAL_CONFIG"
fi

if [[ -s $DOTFILES_LOCAL_CONFIG ]] ; then
  source $DOTFILES_LOCAL_CONFIG
fi

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
