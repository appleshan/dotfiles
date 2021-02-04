#!/usr/bin/python3
import os

key = input().split()[0][:-1].split('+')
for i in range(len(key)):
    if len(key[i]) == 1:
        key[i] = key[i].lower()
    elif key[i].lower() in ('ctrl','super','alt', 'shift'):
        key[i] = key[i].lower()
key = '+'.join(key)

os.system('xdotool key ' + key)
