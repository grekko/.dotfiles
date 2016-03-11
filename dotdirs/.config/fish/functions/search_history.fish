# vim: set ft=sh :
function search_history --description 'Search history with pick'
  set evalfn /tmp/pick_hist
  history | pick > $evalfn
  eval (cat $evalfn)
  rm $evalfn
end
