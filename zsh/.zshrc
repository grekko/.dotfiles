# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set to the name theme to load.
# Look in ~/.oh-my-zsh/themes/
export ZSH_THEME="grekko"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git bundler github brew rails3)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
source ~/.dotfiles/zsh/zshrc-functions
source ~/.dotfiles/zsh/zshrc-aliases
source ~/.dotfiles/zsh/zshrc-bindkeys

# git flow completion
source ~/.git-flow-completion/git-flow-completion.zsh

# Source the profile
if [ -f ~/.profile ]; then
. ~/.profile
fi

if [[ -s ~/.rvm/scripts/rvm ]] ; then source ~/.rvm/scripts/rvm ; fi

# rvm prompt
PS1="\$(~/.rvm/bin/rvm-prompt v g) $PS1"
