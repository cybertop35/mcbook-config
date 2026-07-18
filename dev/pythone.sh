#!/usr/bin/env bash

###############################################################################
# Python AI/Data environment
###############################################################################

set -euo pipefail


log() {
    printf "[Python] %s\n" "$1"
}


log "Installing Python tools"


brew install python uv pipx \
2>/dev/null || true


###############################################################################
# Configure uv
###############################################################################

uv python install 3.13


###############################################################################
# pipx environment
###############################################################################

pipx ensurepath


###############################################################################
# Useful AI/Data tools
###############################################################################

PYTHON_TOOLS=(

ruff
poetry

)


for tool in "${PYTHON_TOOLS[@]}"
do

pipx install "$tool" \
2>/dev/null || true

done


###############################################################################
# Shell configuration
###############################################################################

cat <<EOF >> ~/.zshrc

export PYTHONUNBUFFERED=1

EOF


python3 --version

uv --version


log "Python environment completed"