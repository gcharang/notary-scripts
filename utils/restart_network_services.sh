#!/bin/bash

# usage: ./restart_network_services.sh enp1s0f0

sudo ifdown $1
sudo ifup $1
