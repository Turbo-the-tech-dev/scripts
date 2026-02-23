#!/usr/bin/env bash
# Name: at-st-patrol.sh
# Purpose: Threat detection and security scanning.
# Measurable Outcome: Identify suspicious files, processes, and network activity.
# Usage: ./at-st-patrol.sh [target_directory]

set -e

TARGET="${1:-.}"

echo "[*] AT-ST PATROL UNIT DEPLOYED"
echo "    Scanning Sector: $TARGET"
echo ""

THREAT_COUNT=0

# Function to report threats
report_threat() {
    local level="$1"
    local message="$2"
    echo "[!] THREAT [$level]: $message"
    ((THREAT_COUNT++))
}

echo "=== SCANNING FOR SUSPICIOUS FILES ==="

# Check for world-writable files
if [ -d "$TARGET" ]; then
    WRITABLE=$(find "$TARGET" -type f -perm -002 2>/dev/null | head -10)
    if [ -n "$WRITABLE" ]; then
        report_threat "MEDIUM" "World-writable files detected:"
        echo "$WRITABLE"
    fi
fi

# Check for files with SUID bit
SUID_FILES=$(find "$TARGET" -type f -perm -4000 2>/dev/null | head -10)
if [ -n "$SUID_FILES" ]; then
    report_threat "HIGH" "SUID files detected:"
    echo "$SUID_FILES"
fi

# Check for hidden executable files
HIDDEN_EXEC=$(find "$TARGET" -type f -name ".*" -executable 2>/dev/null | head -10)
if [ -n "$HIDDEN_EXEC" ]; then
    report_threat "MEDIUM" "Hidden executable files:"
    echo "$HIDDEN_EXEC"
fi

echo ""
echo "=== SCANNING FOR SUSPICIOUS PROCESSES ==="

# Check for unknown processes (basic check)
if command -v ps &> /dev/null; then
    # Look for processes with suspicious names
    SUSPICIOUS_PROCS=$(ps aux 2>/dev/null | grep -E "(nc|netcat|ncat|/tmp/)" | grep -v grep | head -5)
    if [ -n "$SUSPICIOUS_PROCS" ]; then
        report_threat "HIGH" "Suspicious processes detected:"
        echo "$SUSPICIOUS_PROCS"
    fi
fi

echo ""
echo "=== SCANNING NETWORK CONNECTIONS ==="

# Check for unusual network connections
if command -v netstat &> /dev/null; then
    ESTABLISHED=$(netstat -an 2>/dev/null | grep ESTABLISHED | wc -l)
    echo "    Established Connections: $ESTABLISHED"
    
    # Check for connections on suspicious ports
    SUSPICIOUS_PORTS=$(netstat -an 2>/dev/null | grep -E ":(4444|5555|6666|31337)" | head -5)
    if [ -n "$SUSPICIOUS_PORTS" ]; then
        report_threat "CRITICAL" "Connections on suspicious ports:"
        echo "$SUSPICIOUS_PORTS"
    fi
elif command -v ss &> /dev/null; then
    ESTABLISHED=$(ss -an 2>/dev/null | grep ESTAB | wc -l)
    echo "    Established Connections: $ESTABLISHED"
fi

echo ""
echo "=== CHECKING RECENT FILE MODIFICATIONS ==="

# Files modified in last hour
if [ -d "$TARGET" ]; then
    RECENT=$(find "$TARGET" -type f -mmin -60 2>/dev/null | head -10)
    if [ -n "$RECENT" ]; then
        echo "    Recently Modified (last 60 min):"
        echo "$RECENT"
    fi
fi

echo ""
echo "=== SYSTEM INTEGRITY CHECK ==="

# Check if running as root (security risk on some systems)
if [ "$(id -u)" -eq 0 ]; then
    report_threat "LOW" "Running as root user"
fi

# Check PATH for current directory
if [[ ":$PATH:" == *":.:"* ]]; then
    report_threat "MEDIUM" "Current directory (.) in PATH"
fi

echo ""
echo "==================================="
echo "    PATROL REPORT COMPLETE"
echo "    Threats Detected: $THREAT_COUNT"
echo "==================================="

if [ "$THREAT_COUNT" -eq 0 ]; then
    echo "[###] SECTOR SECURE. NO THREATS DETECTED."
    exit 0
else
    echo "[!] ACTION REQUIRED: Review threats above."
    exit 1
fi
