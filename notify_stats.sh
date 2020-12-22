#!/bin/bash

set -euxo pipefail

cd ~/nntools

./stats >~/notary-scripts/discord/temp_stats
tr '@' ' ' <~/notary-scripts/discord/temp_stats >~/notary-scripts/discord/temp_stats_string

cd ~/notary-scripts/discord

STATS_DATA="$(cat temp_stats_string)"

STATS_WH="$(cat STATS_WH)"

./discord.sh --webhook-url=$STATS_WH --text="$STATS_DATA"
