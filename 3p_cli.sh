#!/bin/bash

args="$@"

echo "KMD"
komodo-cli $args

echo "HUSH"
hush-cli $args

echo "CHIPS"
chips-cli $args

echo "GAME"
gamecredits-cli $args

echo "EMC2"
einsteinium-cli $args

echo "AYA"
aryacoin-cli $args

echo "VRSC"
verus $args
