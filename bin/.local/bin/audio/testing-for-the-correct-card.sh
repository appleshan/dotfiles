#!/bin/bash

#Testing for the correct card
aplay -D plughw:0,0 /usr/share/sounds/alsa/Front_Right.wav
aplay -D plughw:0,0 /usr/share/sounds/alsa/Front_Left.wav

#
speaker-test -c 2 -D default -t wav
speaker-test -c 2 -D pipewire -t wav

