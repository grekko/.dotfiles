#!/bin/sh
# Handles alerter click action — switches to the correct iTerm2 tab and tmux pane
# Usage: notify-click.sh <tmux_target> <iterm_tty>

tmux_target="$1"
iterm_tty="${2:-}"

if [ -n "$iterm_tty" ]; then
  osascript -e "
    tell application \"iTerm2\"
      activate
      set target_tty to \"$iterm_tty\"
      repeat with w in windows
        repeat with t in tabs of w
          repeat with s in sessions of t
            if tty of s is target_tty then
              tell w to select t
              return
            end if
          end repeat
        end repeat
      end repeat
    end tell
  " 2>/dev/null
else
  open -a iTerm
fi

if [ -n "$tmux_target" ]; then
  tmux select-pane -t "$tmux_target" 2>/dev/null
fi
