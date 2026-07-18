#!/usr/bin/env bash


check_macos_version()
{

VERSION=$(sw_vers -productVersion)

echo "macOS version: $VERSION"

}


check_architecture()
{

ARCH=$(uname -m)

echo "Architecture: $ARCH"

}


check_disk()
{

FREE=$(df -h / | awk 'NR==2 {print $4}')

echo "Free disk: $FREE"

}


check_memory()
{

memory_pressure

}


check_homebrew()
{

if command -v brew >/dev/null
then
echo "Homebrew OK"
else
echo "Homebrew missing"
fi

}


run_checks()
{

check_macos_version
check_architecture
check_disk
check_memory
check_homebrew

}