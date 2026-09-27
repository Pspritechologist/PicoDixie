#!/usr/bin/env sh
set -e

cmake --build build --target pengco_fort

if [ "$1" != "dry" ]; then
	picotool load -x build/pengco_fort.uf2
	exec picocom /dev/ttyACM0
fi
