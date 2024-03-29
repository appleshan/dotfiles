# Settings

# Unbind all default bindings.
unbind-key -T prefix -a
unbind-key -T root -a
unbind-key -T copy-mode -a
unbind-key -T copy-mode-vi -a

########## RESET THE COMMAND PREFIX #############
#              Set default prefix.              #
            set-option -g prefix C-a
#################################################

# Start with non-login shell.
set-option -g default-command "$SHELL"

# Enable true colours
set-option -g default-terminal "xterm-256color"
set-option -g -a terminal-overrides ",xterm-256color:Tc"

# Enable vi style key bindings in command mode.
set-option -g mode-keys vi
set-option -g status-keys vi

# Mouse support.
set-option -g mouse on

# Keep commands history and set its limit.
set-option -g history-file ~/.tmux/cache/history

# Start window numbers at 1 to match keyboard order with tmux window order.
set-option -g base-index 1
set-option -g pane-base-index 1

# Renumber windows sequentially after closing any of them.
# window 0, 1, 2, remove 1, renumber to 0, 1
set-option -g renumber-windows on

# Don't show "Activity in window X" messages.
# set-option -g visual-activity off
# Notifying if other windows has activities
set-window-option -g monitor-activity on
set-option -g visual-activity on

# Turn on automatic window renaming.
set-option -g automatic-rename off
# Allow programs to change title using a escape sequence.
set-option -g allow-rename off

