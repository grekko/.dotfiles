function battery_charge {
    echo `$BAT_CHARGE` 2>/dev/null
}

PROMPT='${PWD/#$HOME/~}
%{$fg_bold[red]%}➜ %{$fg_bold[green]%}%p %{$fg[white]%}%c %{$fg_bold[red]%}$(git_prompt_info) %{$fg_bold[yellow]%}$(parse_git_stash) %{$fg_bold[blue]%} % %{$reset_color%}'
RPROMPT='$(battery_charge) %*'

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[white]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[white]%}$fg[red])"
