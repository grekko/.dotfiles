export DOTFILES_HOME="${HOME}/.dotfiles"
export DOTFILES_HOSTNAME=`hostname -f`
export DOTFILES_USER=`whoami`
export DOTFILES_BASH_CONFIG="${HOME}/.bash/machines/${DOTFILES_USER}@${DOTFILES_HOSTNAME}"
export DOTFILES_SHELL_CONFIG="${HOME}/.bashrc"

if [[ -s $DOTFILES_BASH_CONFIG ]]; then
  source $DOTFILES_BASH_CONFIG
else
  echo "No host specific bashrc found. You can create one here: ${DOTFILES_BASH_CONFIG}"
fi

# Add .scripts to PATH
export PATH="${HOME}/.scripts:$PATH"

# Load shell aliases
source "${HOME}/.shell_aliases"

[[ -s $HOME/.bashrc.local ]] && source $HOME/.bashrc.local
