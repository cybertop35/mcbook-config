#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/logger.sh"


log "Installing terminal tools"


brew install \

fzf \
bat \
eza \
fd \
ripgrep \
zoxide \
tree \
htop \
jq


###############################################################################
# fzf integration
###############################################################################

$(brew --prefix)/opt/fzf/install \
--all \
--no-bash \
--no-fish \
--no-update-rc \
2>/dev/null || true


###############################################################################
# Aliases
###############################################################################

cat <<'EOF' >> ~/.zshrc


alias ll="eza -lah"

alias la="eza -la"

alias cat="bat"

alias grep="rg"


eval "$(zoxide init zsh)"

EOF


log "Terminal configuration completed"