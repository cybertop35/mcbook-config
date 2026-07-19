#!/usr/bin/env bash

UTILS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$UTILS_DIR/logger.sh"

SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"


require_macos()
{

if [[ "$(uname)" != "Darwin" ]]
then
    error "This script requires macOS"
    exit 1
fi

}


restart_services()
{

killall Finder 2>/dev/null || true
killall Dock 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

}


write_default()
{
local domain="$1"
local key="$2"
local type="$3"
shift 3

defaults write "$domain" "$key" "-$type" "$@" 2>/dev/null || true
}


confirm()
{

read -p "$1 (y/n): " answer

[[ "$answer" == "y" ]]

}


timestamp()
{
date +"%Y%m%d_%H%M%S"
}
