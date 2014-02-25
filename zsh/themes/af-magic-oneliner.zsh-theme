# af-magic.zsh-theme
#
# Author: Andy Fleming
# URL: http://andyfleming.com/
# Repo: https://github.com/andyfleming/oh-my-zsh
# Direct Link: https://github.com/andyfleming/oh-my-zsh/blob/master/themes/af-magic.zsh-theme
#
# Created on:		June 19, 2012
# Last modified on:	June 20, 2012

# colors
autoload -U colors && colors
eval my_gray='$FG[237]'
eval my_orange='$FG[214]'

if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
local return_code="%(?..%{$fg[red]%}%? » %{$reset_color%})"

PROMPT='${return_code}$(git_prompt_info)$(prompt_ruby_version)$(prompt_git_stash_indicator)$(git_prompt_newline)$FG[105]%(!.#.») %{$reset_color%}'

# right prompt
RPROMPT='$(pwd) $my_gray%n@%m%{$reset_color%}%'

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX="$FG[075](branch:"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="$my_orange*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$FG[075])%{$reset_color%}"

function git_prompt_newline() {
  if [ -d .git ]; then
    echo "%{$fg[yellow]%}
 "
  fi
}


# monkey patch git_prompt_info
function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return

  pivotal_story_id_length=8
  truncated_branch=${ref#refs/heads/}
  if [[ ${#${truncated_branch}} -gt 30 ]]; then
    truncated_branch=$truncated_branch[0,20]..$truncated_branch[-$pivotal_story_id_length,-1]
  fi

  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${truncated_branch}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function git_stash_indicator() {
  if [[ -n $(git stash list 2> /dev/null) ]]; then
    echo "⚡ got stash"
  fi
}

function prompt_git_stash_indicator() {
  echo "%{$fg[red]%}$(git_stash_indicator)"
}

function ruby_version() {
  if which rvm-prompt &> /dev/null; then
    rvm-prompt i v g
  else
    if which rbenv &> /dev/null; then
      rbenv version | sed -e "s/ (set.*$//"
    fi
  fi
}

function prompt_ruby_version() {
  RUBY_VERSION=$(ruby_version)
  # if RUBY_VERSION; then
   echo  "%{$fg[green]%}(${RUBY_VERSION}) "
  # fi
}

# Highlight Status Exit Code
highlight()
{
    if [ -x /usr/bin/tput ]
    then
        tput bold
        tput setaf $1
    fi
    shift
    printf -- "$@"
    if [ -x /usr/bin/tput ]
    then
        tput sgr0
    fi
}

highlight_error()
{
    highlight 1 "$@"
}

highlight_exit_code()
{
    exit_code=$?
    if [ $exit_code -ne 0 ]
    then
        highlight_error "$exit_code "
    fi
}
