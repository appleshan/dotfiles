#!/bin/bash
# resizes & places the window

#define the height in px of the top system-bar:
TOP_MARGIN=52
BOTTOM_MARGIN=34

#sum in px of all horizontal borders:
RIGHT_MARGIN=2 #7

# get width of screen and height of screen
SCREEN_WIDTH=$(xwininfo -root | awk '$1=="Width:" {print $2}')
SCREEN_HEIGHT=$(xwininfo -root | awk '$1=="Height:" {print $2}')

Full_W=$SCREEN_WIDTH
Haft_W=$(( $SCREEN_WIDTH / 2 - $RIGHT_MARGIN - 4 ))
#Full_H=$(( $SCREEN_HEIGHT - 2 * $TOP_MARGIN ))
Full_H=$(( $SCREEN_HEIGHT - $TOP_MARGIN - $BOTTOM_MARGIN + 2 ))
#Haft_H=$(( ($SCREEN_HEIGHT - $TOP_MARGIN) /2 ))
Haft_H=$(( ($SCREEN_HEIGHT - $TOP_MARGIN - $BOTTOM_MARGIN - 26) /2 ))

# Left
L_W=$Haft_W
L_H=$Full_H
L_X=2;
L_Y=$TOP_MARGIN

# Left Top
LT_W=$Haft_W
LT_H=$Haft_H
LT_X=2;
LT_Y=$TOP_MARGIN

#Left Bottom
LB_W=$Haft_W
LB_H=$Haft_H
LB_X=2;
LB_Y=$(( $SCREEN_HEIGHT/2 + $TOP_MARGIN/2 - 2 ))

#Right
R_W=$Haft_W
R_H=$Full_H
R_X=$(( $SCREEN_WIDTH / 2 ))
R_Y=$TOP_MARGIN

#Right Top
RT_W=$Haft_W
RT_H=$Haft_H
RT_X=$(( $SCREEN_WIDTH / 2 ))
RT_Y=$TOP_MARGIN

#Right Bottom
RB_W=$Haft_W
RB_H=$Haft_H
RB_X=$(( $SCREEN_WIDTH / 2 ))
RB_Y=$(( $SCREEN_HEIGHT/2 + $TOP_MARGIN/2 - 2 ))

#Center
C_W=$Haft_W
C_H=$Haft_H
C_X=$(( $SCREEN_WIDTH/2 - $Haft_W/2 - 4 ))
C_Y=$(( $SCREEN_HEIGHT/2 - $Haft_H/2 + 4 ))

case "$1" in
    "L")   wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz && wmctrl -r :ACTIVE: -e 0,$L_X,$L_Y,$L_W,$L_H ;;
    "LT")  wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz && wmctrl -r :ACTIVE: -e 0,$LT_X,$LT_Y,$LT_W,$LT_H ;;
    "LB")  wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz && wmctrl -r :ACTIVE: -e 0,$LB_X,$LB_Y,$LB_W,$LB_H ;;
    "M")   wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz ;;
    "C")   wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz && wmctrl -r :ACTIVE: -e 0,$C_X,$C_Y,$C_W,$C_H ;;
    "U")   wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz ;;
    "R")   wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz && wmctrl -r :ACTIVE: -e 0,$R_X,$R_Y,$R_W,$R_H ;;
    "RT")  wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz && wmctrl -r :ACTIVE: -e 0,$RT_X,$RT_Y,$RT_W,$RT_H ;;
    "RB")  wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz && wmctrl -r :ACTIVE: -e 0,$RB_X,$RB_Y,$RB_W,$RB_H ;;
*) printf "%s\n" "Usage: ./window [L,R,LT,LB,RT,RB,M,U,C]"; exit ;;
esac

