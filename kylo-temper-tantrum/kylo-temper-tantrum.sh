#!/usr/bin/env bash
# Name: kylo-temper-tantrum.sh
# Purpose: Mobile-safe CPU/memory stress testing.
# Measurable Outcome: System stress metrics without overheating.
# Usage: ./kylo-temper-tantrum.sh [duration_seconds] [intensity: low|med|high]

set -e

DURATION="${1:-30}"
INTENSITY="${2:-low}"

echo "[*] KYLO TEMPER TANTRUM INITIATED"
echo "    Duration: ${DURATION}s"
echo "    Intensity: $INTENSITY"
echo "    WARNING: This will spike CPU usage!"
echo ""

# Safety check for mobile environment
if [ -f /sys/class/power_supply/battery/temp ]; then
    TEMP=$(cat /sys/class/power_supply/battery/temp 2>/dev/null)
    if [ "${TEMP:-0}" -gt 450 ]; then
        echo "[!] ABORT: Battery temperature too high (${TEMP}°C)"
        exit 1
    fi
    echo "    Current Battery Temp: ${TEMP}°C"
fi

# Intensity settings
case "$INTENSITY" in
    low)
        WORKERS=1
        LOOPS=10000
        ;;
    med)
        WORKERS=2
        LOOPS=50000
        ;;
    high)
        WORKERS=4
        LOOPS=100000
        ;;
    *)
        echo "[!] Unknown intensity. Use: low, med, high"
        exit 1
        ;;
esac

echo "    Workers: $WORKERS | Loops: $LOOPS"
echo ""

# Cleanup on exit or interrupt
cleanup() {
    echo -e "\n[###] TANTRUM ENDED. System calming..."
    kill $(jobs -p) 2>/dev/null || true
    exit 0
}
trap cleanup INT TERM EXIT

# Stress function
stress_cpu() {
    local id=$1
    local count=0
    while [ $count -lt $LOOPS ]; do
        # Mathematical operations to spike CPU
        result=$((id * id * id + id))
        ((count++))
    done
    echo "[Worker $id] Complete"
}

# Memory stress (allocate arrays)
stress_mem() {
    local size=$1
    echo "[Memory] Allocating ${size}MB..."
    dd if=/dev/zero of=/tmp/kylo_mem_test_$$ bs=1M count=$size 2>/dev/null || true
    sleep 2
    rm -f /tmp/kylo_mem_test_$$
}

echo "[*] INITIATING STRESS SEQUENCE..."
START_TIME=$(date +%s)

# Launch CPU workers
for ((i=1; i<=WORKERS; i++)); do
    stress_cpu $i &
done

# Memory stress based on intensity
case "$INTENSITY" in
    low)  stress_mem 10 ;;
    med)  stress_mem 25 ;;
    high) stress_mem 50 ;;
esac

# Wait for duration or completion
REMAINING=$DURATION
while [ $REMAINING -gt 0 ]; do
    echo "    Time remaining: ${REMAINING}s"
    sleep 1
    ((REMAINING--))
    
    # Check temperature during stress
    if [ -f /sys/class/power_supply/battery/temp ]; then
        TEMP=$(cat /sys/class/power_supply/battery/temp 2>/dev/null)
        if [ "${TEMP:-0}" -gt 500 ]; then
            echo "[!] SAFETY: Temperature threshold reached. Aborting."
            break
        fi
    fi
done

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))

echo ""
echo "[###] STRESS TEST COMPLETE"
echo "    Elapsed Time: ${ELAPSED}s"
echo "    Workers Launched: $WORKERS"

# Final temperature check
if [ -f /sys/class/power_supply/battery/temp ]; then
    FINAL_TEMP=$(cat /sys/class/power_supply/battery/temp 2>/dev/null)
    echo "    Final Battery Temp: ${FINAL_TEMP}°C"
fi
