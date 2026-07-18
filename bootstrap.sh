#!/usr/bin/env bash

set -e


ROOT="$(cd "$(dirname "$0")" && pwd)"


source "$ROOT/lib/logger.sh"
source "$ROOT/lib/utils.sh"


require_macos


info "Starting Mac bootstrap"


mkdir -p logs backup config


if ! command -v brew >/dev/null
then

info "Installing Homebrew"

/bin/bash -c \
"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

fi


info "Bootstrap completed"

echo

echo "Next:"
echo "./backup.sh"
echo "./apply.sh"