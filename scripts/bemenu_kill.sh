#!/usr/bin/env bash

source "$(dirname "$0")/bemenu_theme.sh"

selected=$(ps -eo pid,user,comm,pcpu,pmem --no-headers | \
    grep -v '\[' | \
    sort -k4 -rn | \
    awk '{
        left  = sprintf("%7s  %-12s  %-20s", $1, $2, $3)
        right = sprintf("cpu:%5s%%  mem:%5s%%", $4, $5)
        pad   = 90 - length(left) - length(right)
        printf "%s%*s%s\n", left, (pad > 2 ? pad : 2), "", right
    }' | \
    bemenu "${bemenu_config[@]}" -p "Kill:")

if [[ -n "$selected" ]]; then
    selpid=$(awk '{print $1}' <<< "$selected")
    pname=$(awk '{print $3}' <<< "$selected")

    answer=$(echo -e "Yes\nNo" | \
             bemenu "${bemenu_config[@]}" -p "Kill $pname (PID $selpid)?")

    if [[ "$answer" == "Yes" ]]; then
        if ! kill -9 "$selpid" 2>/dev/null; then
            pkexec kill -9 "$selpid"
        fi
    fi
fi
