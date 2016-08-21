export DOTFILES_HOME="${HOME}/.dotfiles"
export DOTFILES_HOSTNAME=`hostname -f`
export DOTFILES_HOST_BASH_CONFIG="${HOME}/.bashrc/machines/${DOTFILES_HOSTNAME}"
export DOTFILES_SHELL_CONFIG="${HOME}/.bashrc"

if [[ -s $DOTFILES_HOST_BASH_CONFIG ]]; then
  source $DOTFILES_HOST_BASH_CONFIG
else
  echo "No host specific bashrc found. You can create one here: ${DOTFILES_HOST_BASH_CONFIG}"
fi

# Add .scripts to PATH
export PATH="${HOME}/.scripts:$PATH"

[[ -s $HOME/.bashrc.local ]] && source $HOME/.bashrc.local
