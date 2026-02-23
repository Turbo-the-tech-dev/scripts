#!/usr/bin/env bash
# Name: ewok-victory-dance.sh
# Purpose: Celebration/notifications for successful operations.
# Measurable Outcome: Visual and audio feedback on task completion.
# Usage: ./ewok-victory-dance.sh [message]

set -e

MESSAGE="${1:-Victory achieved!}"

echo "[*] INITIATING EWOK VICTORY DANCE"
echo ""

# ASCII Art Victory
cat << 'EOF'
    \o/      \o/      \o/
     |        |        |
    / \      / \      / \
   EWOK     EWOK     EWOK
    \o/      \o/
     |   +    |
    / \      / \
   VICTORY DANCE!
EOF

echo ""
echo "==================================="
echo "  $MESSAGE"
echo "==================================="
echo ""

# Audio feedback (if available)
if command -v beep &> /dev/null; then
    echo "[♪] Playing victory fanfare..."
    beep -f 523 -l 100  # C5
    beep -f 659 -l 100  # E5
    beep -f 784 -l 200  # G5
    beep -f 1047 -l 300 # C6
elif command -v termux-vibrate &> /dev/null; then
    echo "[♪] Vibrating celebration..."
    termux-vibrate -d 500
else
    echo "[!] No audio/vibration available. Visual celebration only."
fi

# Figlet celebration (if available)
if command -v figlet &> /dev/null; then
    echo ""
    figlet -w 40 "VICTORY!"
fi

# Toast notification (Termux)
if command -v termux-toast &> /dev/null; then
    termux-toast "Victory achieved!"
fi

echo ""
echo "[###] CELEBRATION COMPLETE. THE EWOKS REJOICE!"
