function claude
    argparse f/force -- $argv
    or return 1

    # Only manage the lock inside a git-versioned directory.
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        command claude $argv
        return $status
    end

    # Force: bypass the running-instance check and don't touch the lock.
    if set -q _flag_force
        command claude $argv
        return $status
    end

    set -l lockfile (pwd)/.claude-instance.lock

    if test -f $lockfile
        set -l pid (cat $lockfile)
        if kill -0 $pid 2>/dev/null
            echo "Another Claude instance (PID $pid) is already running in this directory."
            echo "Use a different worktree, pass -f to force, or stop the other instance first."
            return 1
        else
            rm -f $lockfile
        end
    end

    echo %self > $lockfile
    command claude $argv
    set -l exit_code $status
    rm -f $lockfile
    return $exit_code
end
