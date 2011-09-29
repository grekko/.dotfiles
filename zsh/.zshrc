# Path to .dotfiles
export DOTFILES_HOME=~/.dotfiles

# Source .dotfilesrc
source ${DOTFILES_HOME}/.dotfiles-source

# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set to the name theme to load.
# Look in ~/.oh-my-zsh/themes/
export ZSH_THEME="grekko"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git rails3 bundler github brew git-flow gem rvm thor cloudapp vagrant)

source $ZSH/oh-my-zsh.sh

setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data
setopt HIST_IGNORE_SPACE
setopt APPEND_HISTORY # write history only when closing
setopt EXTENDED_HISTORY # add more info

HISTFILE=~/.zsh_history
SAVEHIST=10000
HISTSIZE=10000

REPORTTIME=10 # Show elapsed time if command took more than X seconds
LISTMAX=0 # ask to complete if top of list would scroll off screen

# Load completions for Ruby, Git, etc.
autoload compinit
compinit

# VI behaviour
#set -o vi
#bindkey -v

# Customize to your needs...
source ~/.dotfiles/zsh/zshrc-env
source ~/.dotfiles/zsh/zshrc-functions
source ~/.dotfiles/zsh/zshrc-aliases
source ~/.dotfiles/zsh/zshrc-bindkeys
source ~/.dotfiles/zsh/zshrc-completion

if [[ -s ~/.rvm/scripts/rvm ]] ; then source ~/.rvm/scripts/rvm ; fi

# rvm prompt
PS1="\$(~/.rvm/bin/rvm-prompt v g) $PS1"
