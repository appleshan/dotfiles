##################################
#  Setup Colours and Status Bar  #
##################################

# Mode
set-option -g mode-style bg=brightblack,fg=default

# Use top tabbar
set-option -g status-position top

# Status update interval
set-option -g status-interval 5  # 每 5 秒更新一次状态栏

# Basic status bar colors
set-option -g status-style bg=default,fg=white

# Left side of status bar
set-option -g status-left "#[fg=green]S:#S #[fg=yellow]W:#I #[fg=cyan]P:#P"
set-option -g status-left-length 40

# Window status
#set-option -g window-status-format '#[fg=brightblack,bg=default]  #W  '
#set-option -g window-status-current-format '#[fg=black,bg=blue]  #W  '
#set-option -g window-status-separator '  '
set-option -g status-justify centre

set-option -g window-status-format "#[fg=#eeeeef bg=#343843]#{?window_activity_flag,#[fg=#111111 bg=#cc575d],} #I #W #{?window_bell_flag,,}#{?window_content_flag,,}#{?window_silence_flag,,}#{?window_last_flag,,}"
set-option -g window-status-current-format "#[bg=#5294e2 fg=#ffffff bold] #I #W "
set-option -g window-status-bell-style "fg=#111111 bg=#cc575d bold"
set-option -g window-status-activity-style "fg=#111111 bg=#cc575d bold"
set-option -g window-status-separator '' # Remove space between windows in status bar

# Right side of status bar
### Fancy Font
# status line variables document http://linux.die.net/man/3/strftime
set-option -g status-right "#[fg=cyan]#(date +'%Y-%m-%d %H:%M') " # right part: time lisk 23:59
set-option -g status-right-length 40 # more space left for center part (window names)

# Pane border
#set-option -g pane-border-style bg=default,fg=black
#set-option -g pane-active-border-style bg=default,fg=white
set-option -g pane-border-style bg=default,fg="#cc575d"
set-option -g pane-active-border-style bg=default,fg="#5294e2"

# Pane number indicator
set-option -g display-panes-colour brightblack
set-option -g display-panes-active-colour brightwhite

# Clock mode
set-option -g clock-mode-colour red
set-option -g clock-mode-style 24

# Message
#set-option -g message-style bg=yellow,fg=black
set-option -g message-style bg="#343843",fg="#ffffff"

