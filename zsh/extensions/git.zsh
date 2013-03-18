function current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

function current_repository() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo $(git remote -v | cut -d':' -f 2)
}

alias gpp='git pull origin $(current_branch) && git push origin $(current_branch)'
alias gup='git stash && git pull origin $(current_branch) && git stash pop'
alias gp='git push origin $(current_branch)'
alias gm='git merge' ;compdef git gm
alias gd='git diff'
alias gss='git status -s'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout' ;compdef git gco
alias gb='git branch' ;compdef git gb
alias gba='git branch -a'
alias gbd='git branch -D';compdef git gbd
alias grbm='git rebase master'
