#!/usr/bin/env bash

source "$(dirname "$0")/bemenu_theme.sh"

prompt="-p Path:"
root_path="$HOME"

find_path="$(find $root_path -maxdepth 3 -type d | \
			 sed 's|^'$root_path/'||' | \
			 bemenu "${bemenu_config[@]}" $prompt)"

if [[ ! -z "$find_path" ]]; then
	xdg-open "$find_path"
fi

exit 0
