#!/bin/bash

SCRIPT_DIR="~/notary-scripts"

cd ~/nntools

./stats >$SCRIPT_DIR/discord/temp_stats

cd $SCRIPT_DIR/discord

STATS_DATA=$(cat temp_stats)

STATS_WH=$(cat STATS_WH)

./discord.sh --webhook-url=$STATS_WH --text=$STATS_DATA
