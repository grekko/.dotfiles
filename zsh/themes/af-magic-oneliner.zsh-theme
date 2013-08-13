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
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

PROMPT='$(git_prompt_info)%{$fg[red]%}$(parse_git_stash)%{$fg[yellow]%}$(git_prompt_newline)$FG[105]%(!.#.») %{$reset_color%}'
RPS1='${return_code}'

# right prompt
RPROMPT='$(pwd) $my_gray%n@%m%{$reset_color%}%'

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX="$FG[075](branch:"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="$my_orange*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$FG[075])%{$reset_color%}"

function git_prompt_newline() {
  if [ -d .git ]; then
    echo "
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

# show warning sign if there is something stashed
function parse_git_stash() {
  if [[ -n $(git stash list 2> /dev/null) ]]; then
    echo " ⚡ got stash"
  fi
}
