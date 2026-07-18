#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/logger.sh"


info "Installing container tools"


###############################################################################
# OrbStack preferred on Apple Silicon
###############################################################################

if ! brew list --cask orbstack >/dev/null 2>&1
then

brew install --cask orbstack

fi


###############################################################################
# Kubernetes tools
###############################################################################

brew install kubectl helm k9s \
2>/dev/null || true


###############################################################################
# Verify
###############################################################################

docker version 2>/dev/null || true

kubectl version --client 2>/dev/null || true


log "Docker environment completed"