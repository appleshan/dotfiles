##############################
# Setup addition keybindings #
##############################

# Move panes.
bind-key -T prefix -r \{ swap-pane -U
bind-key -T prefix -r \} swap-pane -D

# Paste
bind-key -T prefix P choose-buffer "paste-buffer -b '%%' -s ''"

# Kill windows without prompt.
bind-key -T prefix x kill-window

# Kill panes without prompt.
bind-key -T prefix X kill-pane

# Jump search mode with prefix.
bind-key -T prefix / copy-mode \; send-keys '/'
bind-key -T prefix ? copy-mode \; send-keys '?'

# Launch command prompt.
bind-key -T prefix : command-prompt

# Show clock.
bind-key -T prefix t clock-mode

# Launch tree mode.
bind-key -T prefix w choose-tree -Zw

# Prefix alternates for root bindings.

# easier and faster switching between next/prev window
bind-key -T prefix p select-window -t :- # Previous window.
bind-key -T prefix n select-window -t :+ # Next window.

bind-key -T prefix v copy-mode

