#!/bin/bash

cd ~/nntools

./stats >~/notary-scripts/discord/temp_stats

cd ~/notary-scripts/discord

STATS_DATA="$(cat temp_stats)"

STATS_WH="$(cat STATS_WH)"

./discord.sh --webhook-url=$STATS_WH --text=$STATS_DATA
