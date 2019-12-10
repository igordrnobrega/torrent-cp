#!/bin/bash

MIGRATION_FOLDER=$1
MIGRATION_TO_FOLDER=$2

for i in $(find "$MIGRATION_FOLDER" -type d \( -name "*.S[0-9]*" \)); do
    sh ./rclonecopy.sh $(basename "$i") "$MIGRATION_TO_FOLDER"
done
