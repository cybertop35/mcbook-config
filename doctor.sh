#!/usr/bin/env bash


ROOT="$(cd "$(dirname "$0")" && pwd)"


source "$ROOT/lib/validation.sh"


echo

echo "=== Mac Bootstrap Doctor ==="

run_checks


echo

echo "Installed developer tools"

command -v git
command -v python3
command -v java
command -v docker
