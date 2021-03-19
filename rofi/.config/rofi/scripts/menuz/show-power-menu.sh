#!/bin/bash

work_path=$(dirname $(readlink -f $0))

MENUZ_DIR=$work_path $work_path/menuz power
