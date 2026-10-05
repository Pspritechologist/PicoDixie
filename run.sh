#!/usr/bin/env bash
set -e

cmd=screen
dry=false

while (($#)); do
	case "$1" in
		--dry) dry=true; shift ;;
		-c*)
			cmd=${1#-c}
			if [[ -z $cmd ]]; then
				if (($# < 2)); then
					printf 'Missing command after -c\n' >&2
					exit 2
				fi
				shift
				cmd=$1
			fi
			shift
			;;
		*) printf 'Unknown argument: %s\n' "$1" >&2; exit 2 ;;
	esac
done

cmake --build build --target pengco_fort

if [[ $dry == false ]]; then
	picotool load -x build/pengco_fort.uf2
	while [ ! -e /dev/ttyACM0 ]; do
		sleep 0.1
	done
	"$cmd" /dev/ttyACM0
fi
