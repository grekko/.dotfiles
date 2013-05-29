# Apple does not load zshenv but zprofile so we check wether we need to source zshenv
if [ ! -z $DOTFILES_HOME ];
  then source $HOME/.zshenv
fi