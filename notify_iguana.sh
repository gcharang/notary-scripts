#!/bin/bash

SCRIPT_DIR="~/notary-scripts"
SERVICE="iguana"
if pgrep -x "$SERVICE"; then
    IGUANA_STATUS=$(echo "$SERVICE is running")
else
    IGUANA_STATUS=$(echo "$SERVICE stopped")
fi

cd $SCRIPT_DIR/discord.sh

IGUANA_WH=$(cat IGUANA_WH)

./discord.sh --webhook-url=$IGUANA_WH --text=$IGUANA_STATUS
