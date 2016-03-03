set -x DOTFILES_HOME $HOME/.dotfiles
set -x DOTFILES_HOSTNAME (hostname -s)
set -x DOTFILES_ENV_PATH $DOTFILES_HOME/fish/environments/$DOTFILES_HOSTNAME

if test -s $DOTFILES_ENV_PATH
  source $DOTFILES_ENV_PATH
else
  echo "Create an environment file to customize your shells env: $DOTFILES_ENV_PATH » Currently running in default mode."
end
