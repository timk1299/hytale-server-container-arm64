#!/bin/sh
set -eu

# Load dependencies
. "$SCRIPTS_PATH/utils.sh"

# Architecture check for Hytale server compatibility
ARCH=$(uname -m)
if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    printf "\n${YELLOW}############################################################${NC}\n"
    printf "${YELLOW}  INFO: EMULATING AMD64 ARCHITECTURE${NC}\n"
    printf "${YELLOW}############################################################${NC}\n"
    printf "${YELLOW} Host architecture:${NC} %s\n" "$ARCH"
    printf "${YELLOW} Status:${NC} Running hytale-downloader through emulation(FEX-Emu).\n"
    printf "${YELLOW}############################################################${NC}\n\n"
fi
