#!/bin/bash
shopt -s extglob

DATETIME=$(date '+%Y-%m-%d %H:%M:%S')

# Catch the first argument to get the folder that will be analysed
TORRENT_FOLDER="$1"
# Set the default directory where the folder will be downloaded
TORRENT_DOWNLOAD_DIR=${2:-"/Users/igornobrega/Movies/Movies"}
# Set the final directory
TORRENT_FINAL_DIR="/Volumes/THAIS LEITE/Plex/series"
TORRENT_PATH="$TORRENT_DOWNLOAD_DIR"/"$TORRENT_FOLDER"

LOG_FILE_NAME="auto_move.log"
LOG_FILE_PATH="$TORRENT_FINAL_DIR"/"$LOG_FILE_NAME"

log() {
    echo "[""$DATETIME""] "$1"" >> "$LOG_FILE_PATH"
}

# Move log file when it reaches a size limit
move_log_file() {
    if [ -f "$LOG_FILE_PATH" ] && [ "$(stat -f%z "$LOG_FILE_PATH")" -gt 100000 ]; then
        log "Moving log file"
        LOG_FILE_COUNT=$(find "$TORRENT_DIR" -maxdepth 1 -name "$LOG_FILE_NAME*" | wc -l)
        sudo mv "$LOG_FILE_PATH" "$LOG_FILE_PATH"."$LOG_FILE_COUNT"
    fi
}

create_log_file() {
    if ! [ -f "$LOG_FILE_PATH" ]; then
        log "Creating log file "$LOG_FILE_PATH""
        touch "$LOG_FILE_PATH"
        sudo chmod 664 "$LOG_FILE_PATH"
        sudo chown igornobrega:staff "$LOG_FILE_PATH"
    fi
}

create_final_path() {
    if ! [ -d "$TORRENT_FINAL_DIR" ]; then
        log "Creating folder "$TORRENT_FINAL_DIR""
        mkdir "$TORRENT_FINAL_DIR"
    fi
}

move_log_file

create_log_file

create_final_path

log "Processing: "$TORRENT_FOLDER""

if [ -d "$TORRENT_PATH" ] && [ "$(find "$TORRENT_PATH" -type d \( -name "*.S[0-9]*" \))" ]; then
    log "Cleaning up "$TORRENT_PATH" folder"

    find "$TORRENT_PATH" -type f -not \( -name "*.mkv" -o -name "*.srt" -o -name "*.mp4" -o -name "*.avi" \) -delete

    FOLDER_NAME=$(echo "$TORRENT_FOLDER" | sed -e 's/.S.*//')
    TORRENT_FINAL_PATH="$TORRENT_FINAL_DIR"/"$FOLDER_NAME"

    if ! [ -d "$TORRENT_FINAL_PATH" ]; then
        log "Creating final path ""$TORRENT_FINAL_PATH"""
        mkdir "$TORRENT_FINAL_PATH"
    fi

    log "Moving "$TORRENT_PATH" to "$TORRENT_FINAL_PATH""

    mv "$TORRENT_PATH"/ "$TORRENT_FINAL_PATH"/

    log "Removing "$TORRENT_PATH""

    # rm -rf "$TORRENT_PATH"/ || true
else
    log "Path not found "$TORRENT_PATH""
fi
