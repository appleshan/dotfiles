#!/usr/bin/python3
from sys import argv
from os.path import expanduser
try:
    path = argv[1]
except IndexError:
    path = expanduser('~/.config/i3/config')

config = open(path,'r')
for line in config:
    if line.startswith('bindsym'):
        keys = line.split()[1]
        line = ' '.join(line.split()[2:])

        idx = line.rfind('#')
        if idx != -1:
            line = line[idx+1:]
        elif line.startswith('exec'):
            line = line[5:]
        elif line == 'workspace next' or line =='workspace prev':
            if line == 'workspace next': line = 'next workspace'
            elif line == 'workspace prev': line = 'previous workspace'
        elif line.startswith('workspace '):
            line = 'go to workspace '+line.split()[1]

        if '$' in keys:
            keys = keys.replace('$','').title()

        print(keys+": "+line, end="\n")
