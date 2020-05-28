#!/bin/bash

# usage: ./restart_network_services.sh enp1s0f0

ifdown $1
ifup $1
