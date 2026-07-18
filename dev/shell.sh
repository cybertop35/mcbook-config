#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/logger.sh"


log "Configuring shell"


###############################################################################
# Oh My Zsh
###############################################################################

if [ ! -d "$HOME/.oh-my-zsh" ]
then

sh -c "$(curl -fsSL \
https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
"" --unattended

fi


###############################################################################
# Plugins
###############################################################################

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}


git clone \
https://github.com/zsh-users/zsh-autosuggestions \
"$ZSH_CUSTOM/plugins/zsh-autosuggestions" \
2>/dev/null || true


git clone \
https://github.com/zsh-users/zsh-syntax-highlighting \
"$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" \
2>/dev/null || true


###############################################################################
# Configure plugins
###############################################################################

sed -i '' \
's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' \
~/.zshrc \
2>/dev/null || true


log "Shell configuration completed"