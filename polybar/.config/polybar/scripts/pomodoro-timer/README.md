# polypomo - a polybar pomodoro widget

## Usage

Download or clone this repository, then in polybar add:

```
; In your bar configuration add
modules-right = <other-modules> polypomo <other-modules>

; and add a polypomo module
[module/polypomo]
type = custom/script

exec = /path/to/pomodoro_timer.py
tail = true

label = %output%
click-left = /path/to/pomodoro_timer.py toggle
click-right = /path/to/pomodoro_timer.py end
click-middle = /path/to/pomodoro_timer.py lock
scroll-up = /path/to/pomodoro_timer.py time +60
scroll-down = /path/to/pomodoro_timer.py time -60
```

In order to prevent accidental changes to the timer, polypomo starts in `locked` mode.  
Middle click the widget or run `pomodoro_timer.py lock` to toggle locked state.  
You can then scroll-up/down to change time.

If you wish to permanently change the default times start polypomo with `--worktime seconds` and `--breaktime seconds`.

### About pomodoro technique

While polypomo implements the `active -> break -> active` pattern it doesn't enforce the longer break after a given number of active sprees.  
This is left at the discretion of the user.


## Optional dependencies

polypomo makes use of `notify-send` to send a notification when the timer reaches zero.


## Screenshots

![pomodoro timer](https://raw.githubusercontent.com/unode/polypomo/master/imgs/tomato-timer.png)  
![break timer](https://raw.githubusercontent.com/unode/polypomo/master/imgs/break-timer.png)
