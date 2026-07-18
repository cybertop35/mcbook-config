#!/usr/bin/env bash


set -e


ROOT="$(cd "$(dirname "$0")" && pwd)"


source "$ROOT/lib/logger.sh"


info "Applying macOS configuration"


MODULES=(

performance
finder
dock
desktop
keyboard
mouse
trackpad
display
battery
spotlight
notifications
security
privacy
login
accessibility
network
power

)


for MODULE in "${MODULES[@]}"
do

FILE="$ROOT/macos/$MODULE.sh"


if [ -f "$FILE" ]
then

info "Running $MODULE"

bash "$FILE"

fi

done


info "All modules applied"