#!/bin/bash

(lsb_release -d | awk {'print $2$3'} ;echo " "; lsb_release -r | awk {'print $2'}) | tr -d '\n'
