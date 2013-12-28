# Apple does not load zshenv but zprofile so we check wether we need to source zshenv
[ ! -z $DOTFILES_HOME ] && source $HOME/.zshenv
