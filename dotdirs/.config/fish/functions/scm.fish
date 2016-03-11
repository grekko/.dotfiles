# vim: set ft=sh :
function scm -d 'Pick and jump into a subdirectory of ~/scm'
  set evalfn /tmp/pick_scm    # define a tmp file to store the pick result
  ls ~/scm | pick >$evalfn    # run pick and store the result
  eval cd ~/scm/(cat $evalfn) # read the content of the file and use it for the cd
  rm $evalfn                  # remove the tmp file afterwards
end
