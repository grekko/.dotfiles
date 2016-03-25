# vim: set ft=sh :

set __fish_git_prompt_show_informative_status 'x'

set __fish_git_prompt_color_prefix 'FFF'
set __fish_git_prompt_color_suffix 'FFF'
set __fish_git_prompt_color_branch '77F'
set __fish_git_prompt_color_flags 'FF0'

function fish_prompt
  # needs to be on top to capture the exactly last status code
  set stat $status

  set -l green (set_color -o AFA)
  set -l red (set_color -o red)
  set -l blue (set_color -o 88F)
  set -l white (set_color -o FFF)
  set -l normal (set_color normal)

  set -l arrow "$white↪ "
  set -l cwd $green(prompt_pwd)
	set status_icon '' # reset icon

  # Set icon if last exit code was not 0
  if test $stat -gt 0
    set status_icon_color (set_color -o red)
		set status_icon "$status_icon_color($stat) "
  end

  # Unfortunately the 'informative' style of fish_git_prompt
  # does not include the stashstate so I build it myself
  set -l stash_icon ''
  set -l git_dir (command git rev-parse --git-dir ^/dev/null)
  if test -n "$git_dir"
    set -l git_has_stash (git stash list|head -1)
    if test -n "$git_has_stash"
      set stash_icon '📋'
    end
  end

  echo -s $cwd (__fish_git_prompt) $stash_icon $normal ' '
  echo -s -n $status_icon $arrow ' '
end
