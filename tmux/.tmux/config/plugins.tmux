###############################
#       Setup Plugin          #
###############################

set-option -g @plugin 'tmux-plugins/tpm'

set-option -g @plugin 'tmux-plugins/tmux-sensible'
# bind C-p previous-window
# bind C-n next-window

set-option -g @plugin 'tmux-plugins/tmux-sidebar'
# prefix + Tab - toggle sidebar with a directory tree
# prefix + Backspace - toggle sidebar and move cursor to it (focus it)

set-option -g @plugin 'tmux-plugins/tmux-urlview'
# prefix + u - listing all urls on bottom pane

set-option -g @plugin 'tmux-plugins/tmux-prefix-highlight'

set-option -g @plugin 'tmux-plugins/tmux-resurrect'
set-option -g @plugin 'tmux-plugins/tmux-continuum'
# Features:
# continuous saving of tmux environment
# automatic tmux start when computer/server is turned on
# automatic restore when tmux is started
set-option -g @continuum-restore 'on'

set-option -g @plugin 'nhdaly/tmux-better-mouse-mode'

# Initialize TMUX plugin manager
run '~/.tmux/plugins/tpm/tpm'

