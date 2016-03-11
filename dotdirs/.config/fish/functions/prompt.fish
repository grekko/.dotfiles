# vim: set ft=sh :
function fish_prompt
  # Save the return status of the previous command
  set stat $status

  if not set -q -g __fish_robbyrussell_functions_defined
    set -g __fish_robbyrussell_functions_defined

    function _is_git_repo
      git status -s >/dev/null ^/dev/null
    end

    function _git_branch_name
      echo (git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
    end
  end

  set -l green (set_color -o green)
  set -l yellow (set_color -o AF0)
  set -l red (set_color -o red)
  set -l blue (set_color -o 88F)
  set -l white (set_color -o FFF)
  set -l normal (set_color normal)

  set -l arrow "$white↪ "
  set -l cwd $yellow(prompt_pwd)

  if _is_git_repo
    set -l repo_branch $white(_git_branch_name)
    set repo_info "$red git:($repo_branch$red)"
  end

  # Status color
	set status_icon ''
  if test $stat -gt 0
    set status_icon_color (set_color -o red)
		set status_icon "$status_icon_color($stat) "
  end

  echo -s $cwd $repo_info $normal ' '
  echo -s -n $status_icon$arrow ' '
end
