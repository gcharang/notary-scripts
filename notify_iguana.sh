#!/bin/bash

SERVICE="iguana"
if pgrep -x "$SERVICE"; then
    IGUANA_STATUS=$(echo "$SERVICE is running")
else
    IGUANA_STATUS=$(echo "$SERVICE stopped")
fi

cd ~/notary-scripts/discord

IGUANA_WH="$(cat IGUANA_WH)"

./discord.sh --webhook-url=$IGUANA_WH --text=$IGUANA_STATUS
