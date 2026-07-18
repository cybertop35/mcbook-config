#!/usr/bin/env bash

###############################################################################
# Java development environment
###############################################################################

set -euo pipefail


log() {
    printf "[Java] %s\n" "$1"
}


log "Installing Java tools"


brew install openjdk@21 maven gradle \
2>/dev/null || true


###############################################################################
# JAVA_HOME
###############################################################################

JAVA_HOME_PATH=$(/usr/libexec/java_home -v 21 2>/dev/null || true)


if [ -n "$JAVA_HOME_PATH" ]
then

echo "" >> ~/.zshrc

echo 'export JAVA_HOME=$(/usr/libexec/java_home -v 21)' \
>> ~/.zshrc

echo 'export PATH=$JAVA_HOME/bin:$PATH' \
>> ~/.zshrc

fi


###############################################################################
# Verify
###############################################################################

java -version || true

mvn -version || true

gradle -version || true


log "Java environment completed"