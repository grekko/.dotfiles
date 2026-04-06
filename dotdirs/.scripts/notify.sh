#!/bin/sh
# Generic macOS notification via alerter with click-to-switch for iTerm2 + tmux.
# Usage:
#   notify.sh --title "Title" --message "Body text"
#   notify.sh --title "Title" --subtitle "Project" --message "Body" --sound Glass
#   notify.sh --title "Title" --message "Body" --icon /path/to/image.png --group mygroup
#
# All flags are optional except --message. Defaults:
#   --title     "Notification"
#   --subtitle  (empty)
#   --sound     "default"
#   --icon      (none)
#   --group     "notify"
#   --timeout   30
#
# Tmux pane and iTerm2 tab are auto-detected from the calling environment.
# Clicking the notification switches to the correct iTerm2 tab and tmux pane.

set -eu

title="Notification"
subtitle=""
message=""
sound="default"
icon=""
group="notify"
timeout=30

while [ $# -gt 0 ]; do
  case "$1" in
    --title)     title="$2";    shift 2 ;;
    --subtitle)  subtitle="$2"; shift 2 ;;
    --message)   message="$2";  shift 2 ;;
    --sound)     sound="$2";    shift 2 ;;
    --icon)      icon="$2";     shift 2 ;;
    --group)     group="$2";    shift 2 ;;
    --timeout)   timeout="$2";  shift 2 ;;
    *) shift ;;
  esac
done

if [ -z "$message" ]; then
  echo "Usage: notify.sh --message \"text\" [--title T] [--subtitle S] [--sound S] [--icon I] [--group G] [--timeout N]" >&2
  exit 1
fi

# Auto-detect tmux pane and iTerm2 tty from the calling environment
tmux_target=""
iterm_tty=""
if [ -n "${TMUX_PANE:-}" ]; then
  tmux_target=$(tmux display-message -t "$TMUX_PANE" -p '#{session_name}:#{window_index}.#{pane_index}' 2>/dev/null || true)
  iterm_tty=$(tmux display-message -p '#{client_tty}' 2>/dev/null || true)
fi

# Build alerter args
argsfile=$(mktemp "${TMPDIR:-/tmp}/notify-args.XXXXXX")
printf '%s\n' "$title" "$subtitle" "$message" "$sound" "$icon" "$group" "$timeout" "$tmux_target" "$iterm_tty" > "$argsfile"

SCRIPTS_DIR="$(cd "$(dirname "$0")" && pwd)"

runner=$(mktemp "${TMPDIR:-/tmp}/notify-runner.XXXXXX")
cat > "$runner" <<SCRIPT
#!/bin/sh
argsfile="$argsfile"
runner="$runner"
title=\$(sed -n '1p' "\$argsfile")
subtitle=\$(sed -n '2p' "\$argsfile")
message=\$(sed -n '3p' "\$argsfile")
sound=\$(sed -n '4p' "\$argsfile")
icon=\$(sed -n '5p' "\$argsfile")
group=\$(sed -n '6p' "\$argsfile")
timeout=\$(sed -n '7p' "\$argsfile")
tmux_target=\$(sed -n '8p' "\$argsfile")
iterm_tty=\$(sed -n '9p' "\$argsfile")

action=\$(alerter \\
  --title "\$title" \\
  --message "\$message" \\
  --sound "\$sound" \\
  --group "\$group" \\
  --timeout "\$timeout" \\
  \${subtitle:+--subtitle "\$subtitle"} \\
  \${icon:+--content-image "\$icon"} \\
  2>/dev/null) || true

if [ "\$action" = "@CONTENTCLICKED" ] || [ "\$action" = "@ACTIONCLICKED" ]; then
  sh "$SCRIPTS_DIR/notify-click.sh" "\$tmux_target" "\$iterm_tty"
fi
rm -f "\$argsfile" "\$runner"
SCRIPT
chmod +x "$runner"
nohup "$runner" >/dev/null 2>&1 &

sleep 1
