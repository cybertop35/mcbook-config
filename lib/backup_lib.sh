#!/usr/bin/env bash


BACKUP_ROOT="$ROOT/backup"

echo "BACKUP_ROOT=$BACKUP_ROOT"
create_backup()
{

BACKUP="$BACKUP_ROOT/backup_$(date +%Y%m%d_%H%M%S)"

mkdir -p "$BACKUP"


echo "Creating backup $BACKUP"


##################################
# macOS preferences
##################################

defaults export NSGlobalDomain \
"$BACKUP/global.plist" 2>/dev/null || true


defaults export com.apple.finder \
"$BACKUP/finder.plist" 2>/dev/null || true


defaults export com.apple.dock \
"$BACKUP/dock.plist" 2>/dev/null || true


##################################
# Applications
##################################

if command -v brew >/dev/null
then

brew bundle dump \
--file="$BACKUP/Brewfile" \
--force

fi


##################################
# Developer configs
##################################

cp ~/.zshrc "$BACKUP/zshrc" 2>/dev/null || true

cp ~/.gitconfig "$BACKUP/gitconfig" 2>/dev/null || true


echo "$BACKUP"

}