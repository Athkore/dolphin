#!/bin/bash -e
# linux-env.sh

# Add /usr/lib/ to LD_LIBRARY_PATH cause Ubuntu is dumb
export LD_LIBRARY_PATH="$(dirname $0)/usr/lib/:$LD_LIBRARY_PATH"

export QT_QPA_PLATFORM=xcb

if [ -z ${DISPLAY} ]; then export DISPLAY=:0; fi

$(dirname $0)/usr/bin/dolphin-emu

