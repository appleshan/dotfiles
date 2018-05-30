# author: lx@shellcodes.org

conn_status=$(xrandr --current | fgrep ' connected ' | fgrep -v 'connected primary ')

output_port=$(echo $conn_status | awk '{print $1}')

if `echo $conn_status | fgrep -q 'connected 1920x1080+0+0 (normal'`;
then
    xrandr --output ${output_port} --auto --right-of DP1
else
    xrandr --output ${output_port} --off
fi
