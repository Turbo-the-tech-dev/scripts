#!/usr/bin/env bash
# Name: ewok-scout.sh
# Purpose: System monitoring and resource tracking.
# Measurable Outcome: Real-time CPU, memory, storage, and network stats.
# Usage: ./ewok-scout.sh [interval_seconds]

set -e

INTERVAL="${1:-5}"

echo "[*] EWOK SCOUT ONLINE - Monitoring Forest Moon Systems"
echo "    Refresh Interval: ${INTERVAL}s"
echo "    Press Ctrl+C to abort"
echo ""

# Cleanup on exit
cleanup() {
    echo -e "\n[###] SCOUT REPORT ENDED."
    exit 0
}
trap cleanup INT TERM

while true; do
    TIMESTAMP=$(date +%H:%M:%S)
    
    echo "=== [$TIMESTAMP] SCOUT REPORT ==="
    
    # CPU Usage
    if command -v top &> /dev/null; then
        CPU_IDLE=$(top -n 1 2>/dev/null | grep -i cpu | awk '{print $8}' | head -1 || echo "N/A")
        echo "CPU Idle: $CPU_IDLE%"
    else
        echo "CPU: [top unavailable]"
    fi
    
    # Memory Usage
    if command -v free &> /dev/null; then
        MEM_INFO=$(free -m 2>/dev/null | grep Mem || echo "N/A")
        echo "Memory: $MEM_INFO MB"
    else
        echo "Memory: [free unavailable]"
    fi
    
    # Storage Usage
    if command -v df &> /dev/null; then
        STORAGE=$(df -h /data 2>/dev/null | tail -1 | awk '{print $5}' || df -h / | tail -1 | awk '{print $5}')
        echo "Storage Used: $STORAGE"
    else
        echo "Storage: [df unavailable]"
    fi
    
    # Network Interfaces
    if command -v ip &> /dev/null; then
        NET_INFO=$(ip addr 2>/dev/null | grep -E "inet " | awk '{print $2}' | head -2 | tr '\n' ' ')
        echo "Network: $NET_INFO"
    elif command -v ifconfig &> /dev/null; then
        NET_INFO=$(ifconfig 2>/dev/null | grep -E "inet " | awk '{print $2}' | head -2 | tr '\n' ' ')
        echo "Network: $NET_INFO"
    else
        echo "Network: [unavailable]"
    fi
    
    # Battery (Android/Termux specific)
    if [ -f /sys/class/power_supply/battery/capacity ]; then
        BATTERY=$(cat /sys/class/power_supply/battery/capacity 2>/dev/null || echo "N/A")
        echo "Battery: ${BATTERY}%"
    fi
    
    echo "-----------------------------------"
    
    sleep "$INTERVAL"
done
