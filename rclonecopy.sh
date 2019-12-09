#!/bin/bash

DATETIME=$(date '+%Y-%m-%d %H:%M:%S')

TORRENT_FOLDER="$1"
TORRENT_DOWNLOAD_DIR="/Users/igornobrega/Movies/Movies"
TORRENT_FINAL_DIR="/Volumes/THAIS LEITE/Plex"
TORRENT_PATH="$TORRENT_DOWNLOAD_DIR"/"$TORRENT_FOLDER"

LOG_FILE_NAME="auto_move.log"
LOG_FILE_PATH="$TORRENT_FINAL_DIR"/"$LOG_FILE_NAME"

log() {
    echo "[""$DATETIME""] "$1"" >> "$LOG_FILE_PATH"
}

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
        mkdir "$TORRENT_DIR"
    fi
}

move_log_file

create_log_file

create_final_path

log "Processing: "$TORRENT_FOLDER""

if [ -d "$TORRENT_PATH" ]; then
    log "Cleaning up "$TORRENT_PATH" folder"

    find "$TORRENT_PATH" -type f | grep -vE '\.(mp4|avi|mkv)$' | xargs rm -f

    FOLDER_NAME=$(echo "$TORRENT_FOLDER" | sed -e 's/.S.*//')
    TORRENT_FINAL_PATH="$TORRENT_FINAL_DIR"/"$FOLDER_NAME"

    if ! [ -d"$TORRENT_FINAL_PATH" ]; then
        log "Creating final path "$TORRENT_FINAL_PATH""
        mkdir "$TORRENT_FINAL_PATH"
    fi

    log "Moving "$TORRENT_PATH" to "$TORRENT_FINAL_PATH""

    mv "$TORRENT_PATH" "$TORRENT_FINAL_PATH"
else
    log "Path not found "$TORRENT_PATH""
fi
