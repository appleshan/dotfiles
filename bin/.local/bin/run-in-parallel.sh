#!/bin/bash

# @see http://baohaojun.github.io/blog/2013/05/29/0-parallel-bash.html
# Example:
# time run-in-parallel -I %N -P 10 'echo %N; sleep 1' $(seq 1 20)

jobs=5
replace_str=
export RUN_IN_PARALLEL=true
TEMP=$(getopt -o P:I: --long parallel: -n $(basename $0) -- "$@")
eval set -- "$TEMP"
while true; do
    case "$1" in
        -P|--parallel)
            jobs=$2
            shift 2
            ;;
        -I)
            replace_str=$2
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            die "internal error"
            ;;
    esac
done

cmd=$1
if test -z "$replace_str" && yes-or-no-p -y "Use %N as replace_str"; then
    replace_str=%N
    cmd="$cmd %N"
fi
shift

for y in "$@"; do
    echo -n "$y";
    echo -n x | tr x \\0
done | xargs -0 -P $jobs -I "$replace_str" bash -c "$cmd"
