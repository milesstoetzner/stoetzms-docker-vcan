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
# Run in the foreground (-D) but in the background of this shell, so that its output reaches the container logs
can2udp -D -fp "$VCAN_SOURCE_PORT" "$VCAN_INTERFACE" "$VCAN_TARGET_IP" "$VCAN_TARGET_PORT" &
CAN2UDP_PID=$!
sleep 1
if ! kill -0 "$CAN2UDP_PID" 2>/dev/null; then
    echo can2udp failed to start >&2
    exit 1
fi
echo Started can2udp

# Listening on vcan
echo Listening on vcan
exec candump "$VCAN_INTERFACE"
