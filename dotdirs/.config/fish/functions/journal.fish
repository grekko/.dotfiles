# vim: set ft=sh :
function journal --description "Opens vim with the current journal file"
  set -l isodate (date -u +"%Y-%m-%d")
  set -l filename $HOME/scm/journals/drafts/$isodate.md
  vim $filename
end

alias j journal

