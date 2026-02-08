#!/bin/sh
set -eu

# Load dependencies
. "$SCRIPTS_PATH/utils.sh"

log_section "Hytale Auto Update"

# Helper function to extract and finalize
extract_server() {
    local zip_file="$1"
    
    log_step "Extracting Game Content"
    
    if [ "${DEBUG:-FALSE}" = "TRUE" ]; then
        printf "      ${DIM}↳ Source:${NC} %s\n" "$(basename "$zip_file")"
        printf "      ${DIM}↳ Target:${NC} ${GREEN}%s${NC}\n" "$GAME_DIR"
    fi
    
    # SAFE EXTRACTION: Only overwrites files from the archive
    # Files not in the archive (user data, configs, mods) remain untouched
#    if 7z x "$zip_file" -aoa -bsp1 -mmt=on -o"$GAME_DIR"; then # >/dev/null 2>&1; then
    if unzip -o "$zip_file" -d "$GAME_DIR" >/dev/null 2>&1; then
        log_success
        if [ "${DEBUG:-FALSE}" = "TRUE" ]; then
            printf "      ${DIM}↳ Note:${NC} Server binaries updated. User data preserved.\n"
        fi
    else
        log_error "Extraction failed" "Check disk space or 7z compatibility."
        exit 1
    fi
    
    log_step "Post-Extraction Cleanup"
    rm -f "$zip_file"
    echo "$(basename "$zip_file" .zip)" > "$BASE_DIR"/latest_version_hytale.txt
    log_success
    
    chown -R container:container "$BASE_DIR" 2>/dev/null || true
    
    log_step "File Permissions"
    chmod -R 755 "$GAME_DIR" && log_success || log_warning "Chmod failed" "May need manual adjustment."
}

# Main logic - Auto Update

log_warning "Auto Update started." "Checking for new version online..."

# get the newest version string
latest_version_online=$(FEX /usr/local/bin/hytale-downloader -print-version 2>/dev/null | tee /dev/tty | tail -1)
if [ -f "$BASE_DIR"/latest_version_hytale.txt ]; then
    installed_version=$(cat "$BASE_DIR"/latest_version_hytale.txt 2>/dev/null)
else
    installed_version=""
fi

if [ "$installed_version" = "$latest_version_online" ]; then
    log_warning "Already newest version. No download needed."
    exit 0
else
    log_warning "New version detected. Downloading files..."
    log_step "Download Status"
    FEX /usr/local/bin/hytale-downloader
fi

ZIP_FILE=$(ls "$BASE_DIR"/[0-9][0-9][0-9][0-9].[0-9][0-9].[0-9][0-9]*.zip 2>/dev/null | head -n 1)
if [ -z "$ZIP_FILE" ]; then
    log_error "Download failed." "Could not find valid YYYY.MM.DD*.zip after download."
    exit 1
fi
log_success

extract_server "$ZIP_FILE"
