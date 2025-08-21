#!/usr/bin/env bash
set -euo pipefail

SESSION="mysetup"
tmux kill-session -t "$SESSION" 2>/dev/null || true

# Start session; only one pane exists (left side)
tmux new-session -d -s "$SESSION"
LEFT=$(tmux display-message -p -t "$SESSION":. "#{pane_id}")

# Split into RIGHT
tmux split-window -h -p 50 -t "$LEFT"
RIGHT=$(tmux display-message -p -t "$SESSION":. "#{pane_id}")

# RIGHT: split into top (TR) and bottom (BR)
tmux split-window -v -p 50 -t "$RIGHT"
BR=$(tmux display-message -p -t "$SESSION":. "#{pane_id}")
tmux select-pane -U -t "$BR"
TR=$(tmux display-message -p -t "$SESSION":. "#{pane_id}")

# LEFT: split into top
tmux select-pane -t "$LEFT"
tmux split-window -v -p 60
BL=$(tmux display-message -p -t "$SESSION":. "#{pane_id}")
tmux select-pane -U
TL=$(tmux display-message -p -t "$SESSION":. "#{pane_id}")

tmux send-keys -t "$TL" 'fastfetch --config ~/github/dotfiles/.config/fastfetch/config_minimal.jsonc' C-m
tmux send-keys -t "$BL" 'htop' C-m
tmux send-keys -t "$TR" 'ranger' C-m
tmux send-keys -t "$BR" 'zsh' C-m

tmux select-pane -t "$TL" -T 'Fastfetch'
tmux select-pane -t "$BL" -T 'HTOP'
tmux select-pane -t "$TR" -T 'Ranger'
tmux select-pane -t "$BR" -T 'Terminal'

tmux attach -t "$SESSION"

# ┌──────────────────────────┬──────────────────────────┐
# │       Fastfetch 1/3      │         Ranger 1/2       │
# ├──────────────────────────┼──────────────────────────┤
# │         btop 2/3         │        Terminal 1/2      │
# └──────────────────────────┴──────────────────────────┘
