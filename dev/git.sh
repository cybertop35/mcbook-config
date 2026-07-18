#!/usr/bin/env bash

###############################################################################
# Git configuration
###############################################################################

set -euo pipefail


log() {
    printf "[Git] %s\n" "$1"
}


log "Configuring Git"


git config --global init.defaultBranch main


git config --global pull.rebase true


git config --global fetch.prune true


git config --global core.autocrlf input


git config --global core.editor \
"code --wait" \
2>/dev/null || true


###############################################################################
# Useful aliases
###############################################################################

git config --global alias.st status

git config --global alias.co checkout

git config --global alias.br branch

git config --global alias.cm commit

git config --global alias.lg \
"log --oneline --graph --decorate --all"


###############################################################################
# Better diff
###############################################################################

git config --global color.ui auto


###############################################################################
# Credential helper
###############################################################################

git config --global credential.helper osxkeychain


log "Git configuration completed"