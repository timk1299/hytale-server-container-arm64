#!/bin/sh
set -eu

# Load dependencies
. "$SCRIPTS_PATH/utils.sh"

log_section "Hytale Downloader"

# 1. Check if the server is already installed
log_step "Hytale Server Binary Check"

if [ ! -f "$SERVER_JAR_PATH" ]; then
    log_warning "HytaleServer.jar not found at $SERVER_JAR_PATH." \
    "Initializing first-time installation/extraction..."

    # 2. Clean up any old zips and download fresh copy
    log_step "Download Status"
    printf "      ${DIM}↳ Info:${NC} Removing old zip files and downloading fresh copy...\n"
    
    # Remove any existing zip files to ensure clean state
    rm -f "$BASE_DIR"/[0-9][0-9][0-9][0-9].[0-9][0-9]*.zip 2>/dev/null || true
    
    # Download fresh copy
    hytale-downloader
    
    # Find the newly downloaded zip
    ZIP_FILE=$(ls "$BASE_DIR"/[0-9][0-9][0-9][0-9].[0-9][0-9]*.zip 2>/dev/null | head -n 1)
    
    if [ -z "$ZIP_FILE" ]; then
        log_error "Download failed." "Could not find a valid YYYY.MM*.zip after running downloader."
        exit 1
    fi
    log_success

    # 3. Extract with 7zip
    log_step "Extracting Game Content"
    printf "      ${DIM}↳ Target:${NC} ${GREEN}%s${NC}\n" "$GAME_DIR"
    
    # SAFE EXTRACTION: Only overwrites files from the archive
    # Files not in the archive (user data, configs, mods) remain untouched
    # x: eXtract with full paths (preserves directory structure)
    # -aoa: Overwrite All - only affects files present in archive
    # -bsp1: Show progress percentage
    # -mmt=on: Multi-threaded extraction for performance
    # -o: Output directory
    if 7z x "$ZIP_FILE" -aoa -bsp1 -mmt=on -o"$GAME_DIR"; then
        log_success
        printf "      ${DIM}↳ Note:${NC} Only server binaries replaced. User data preserved.\n"
    else
        log_error "Extraction failed" "Check disk space or 7z compatibility."
        exit 1
    fi

    # 4. Finalize
    log_step "Post-Extraction Cleanup"
    rm -f "$ZIP_FILE"
    log_success
    
    chown -R container:container /home/container || log_warning "Chown failed" "User or group may not exist."

    log_step "File Permissions"
    if chmod -R 755 "$GAME_DIR"; then
        log_success
    else
        log_warning "Chmod failed" "Permissions might need manual adjustment."
    fi
else
    log_success
    printf "      ${DIM}↳ Info:${NC} HytaleServer.jar exists. Skipping extraction.\n"
fi