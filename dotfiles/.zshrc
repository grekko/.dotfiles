source $DOTFILES_HOME/zsh/lib/git.zsh
source $DOTFILES_HOME/zsh/lib/rvm.zsh
source $DOTFILES_HOME/zsh/lib/spectrum.zsh
source $DOTFILES_HOME/zsh/lib/theme-and-appearance.zsh

source $DOTFILES_HOME/zsh/functions
source $DOTFILES_HOME/zsh/aliases
source $DOTFILES_HOME/zsh/bindkeys
source $DOTFILES_HOME/zsh/bootstrap-env


if [[ -s $DOTFILES_HOME/zsh/configs/`hostname -s` ]] ;
  then source $DOTFILES_HOME/zsh/configs/`hostname -s` ;
else
  echo "Create a config to customize your shell: $DOTFILES_HOME/zsh/configs/`hostname -s` » Currently running in default mode."
fi

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
