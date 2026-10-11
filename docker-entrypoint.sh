#!/bin/sh
set -e

# Display configuration
echo Using following configuration
echo VCAN_INTERFACE: "${VCAN_INTERFACE:=vcan0}"
echo VCAN_SOURCE_PORT: "${VCAN_SOURCE_PORT:=6000}"
echo VCAN_TARGET_IP: "${VCAN_TARGET_IP:=172.17.0.1}"
echo VCAN_TARGET_PORT: "$VCAN_TARGET_PORT"

# Resolving target ip, since VCAN_TARGET_IP might also be a hostname
VCAN_TARGET_HOST="$VCAN_TARGET_IP"
VCAN_TARGET_IP=$(getent ahostsv4 "$VCAN_TARGET_HOST" | head -n 1 | cut -d " " -f 1)
if [ -z "$VCAN_TARGET_IP" ]; then
    echo Could not resolve "$VCAN_TARGET_HOST" >&2
    exit 1
fi
echo Resolved "$VCAN_TARGET_HOST" to "$VCAN_TARGET_IP"

# Setting up vcan
ip link add "$VCAN_INTERFACE" type vcan
ip link set up "$VCAN_INTERFACE"
echo Created vcan

# Setting up can2udp
can2udp -fp "$VCAN_SOURCE_PORT" "$VCAN_INTERFACE" "$VCAN_TARGET_IP" "$VCAN_TARGET_PORT"
echo Started can2udp

# Listening on vcan
echo Listening on vcan
candump "$VCAN_INTERFACE"
