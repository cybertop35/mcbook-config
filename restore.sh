#!/usr/bin/env bash


ROOT="$(cd "$(dirname "$0")" && pwd)"


BACKUP="$1"


if [ -z "$BACKUP" ]
then
echo "Usage:"
echo "./restore.sh backup/path"

exit 1

fi


defaults import NSGlobalDomain \
"$BACKUP/global.plist" || true


defaults import com.apple.finder \
"$BACKUP/finder.plist" || true


defaults import com.apple.dock \
"$BACKUP/dock.plist" || true


if [ -f "$BACKUP/Brewfile" ]
then

brew bundle \
--file="$BACKUP/Brewfile"

fi


killall Finder || true
killall Dock || true


echo "Restore completed"