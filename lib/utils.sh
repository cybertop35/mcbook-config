#!/usr/bin/env bash


SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"


require_macos()
{

if [[ "$(uname)" != "Darwin" ]]
then
    echo "This script requires macOS"
    exit 1
fi

}


restart_services()
{

killall Finder 2>/dev/null || true
killall Dock 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

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