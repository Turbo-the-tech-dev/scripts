#!/usr/bin/env bash
# Name: ewok-guard-duty.sh
# Purpose: Login auditing and perimeter defense.
# Measurable Outcome: Track logins, detect unauthorized access attempts.
# Usage: ./ewok-guard-duty.sh [mode: monitor|report|setup]

set -e

MODE="${1:-monitor}"
LOG_FILE="${HOME}/.ewok_guard_log"
ALERT_FILE="${HOME}/.ewok_alerts"

echo "[*] EWOK GUARD DUTY - Perimeter Defense System"
echo "    Mode: $MODE"
echo "    Log: $LOG_FILE"
echo ""

# Initialize log file
init_log() {
    if [ ! -f "$LOG_FILE" ]; then
        echo "# Ewok Guard Duty Log - Created $(date)" > "$LOG_FILE"
        echo "# Format: TIMESTAMP | EVENT | DETAILS" >> "$LOG_FILE"
    fi
}

# Log an event
log_event() {
    local event="$1"
    local details="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$timestamp | $event | $details" >> "$LOG_FILE"
    echo "[$timestamp] $event: $details"
}

# Record current login
record_login() {
    local user=$(whoami)
    local tty=$(tty)
    local from=$(who am i | awk '{print $5}' | tr -d '()' || echo "local")
    
    log_event "LOGIN" "User: $user | TTY: $tty | From: $from"
    
    # Check for multiple sessions
    SESSION_COUNT=$(who | grep "$user" | wc -l)
    if [ "$SESSION_COUNT" -gt 2 ]; then
        log_event "ALERT" "Multiple sessions detected: $SESSION_COUNT"
        echo "[!] WARNING: Multiple active sessions!"
    fi
}

# Check for failed login attempts (if logs available)
check_failed_logins() {
    echo "=== CHECKING FAILED LOGIN ATTEMPTS ==="
    
    if [ -f /var/log/auth.log ]; then
        FAILED=$(grep "Failed password" /var/log/auth.log 2>/dev/null | tail -10)
        if [ -n "$FAILED" ]; then
            echo "$FAILED"
            log_event "SCAN" "Failed logins found in auth.log"
        else
            echo "    No failed login attempts detected."
        fi
    elif [ -f /var/log/secure ]; then
        FAILED=$(grep "Failed password" /var/log/secure 2>/dev/null | tail -10)
        if [ -n "$FAILED" ]; then
            echo "$FAILED"
            log_event "SCAN" "Failed logins found in secure"
        else
            echo "    No failed login attempts detected."
        fi
    else
        echo "    [!] System logs not accessible (Termux limitation)"
    fi
}

# Monitor mode - continuous watching
monitor_mode() {
    echo "[*] ENTERING CONTINUOUS MONITOR MODE"
    echo "    Press Ctrl+C to exit"
    echo ""
    
    # Record initial login
    record_login
    
    # Cleanup on exit
    cleanup() {
        echo -e "\n[###] GUARD DUTY ENDED. $(date)"
        log_event "END" "Guard duty session terminated"
        exit 0
    }
    trap cleanup INT TERM
    
    local check_count=0
    
    while true; do
        ((check_count++))
        
        # Periodic checks
        if [ $((check_count % 6)) -eq 0 ]; then
            echo ""
            echo "=== PERIODIC CHECK #${check_count} ==="
            
            # Check active users
            ACTIVE=$(who | wc -l)
            echo "    Active Users: $ACTIVE"
            log_event "CHECK" "Active users: $ACTIVE"
            
            # Check current processes
            PROC_COUNT=$(ps aux 2>/dev/null | wc -l)
            echo "    Running Processes: $PROC_COUNT"
            
            # Check for new logins
            NEW_LOGINS=$(who | awk '{print $1}' | sort -u | wc -l)
            echo "    Unique Users: $NEW_LOGINS"
        fi
        
        sleep 10
    done
}

# Report mode - generate summary
report_mode() {
    echo "=== GUARD DUTY REPORT ==="
    echo ""
    
    if [ -f "$LOG_FILE" ]; then
        echo "Log File: $LOG_FILE"
        echo "Created: $(head -1 "$LOG_FILE" | grep -oP '\d{4}-\d{2}-\d{2}' || echo "Unknown")"
        echo ""
        
        TOTAL_EVENTS=$(wc -l < "$LOG_FILE")
        echo "Total Events Logged: $TOTAL_EVENTS"
        
        LOGIN_COUNT=$(grep -c "LOGIN" "$LOG_FILE" 2>/dev/null || echo "0")
        echo "Login Events: $LOGIN_COUNT"
        
        ALERT_COUNT=$(grep -c "ALERT" "$LOG_FILE" 2>/dev/null || echo "0")
        echo "Alert Events: $ALERT_COUNT"
        
        echo ""
        echo "=== RECENT ACTIVITY (Last 10 entries) ==="
        tail -10 "$LOG_FILE"
    else
        echo "    No log file found. Run in 'monitor' mode first."
    fi
    
    echo ""
    check_failed_logins
}

# Setup mode - configure guard duty
setup_mode() {
    echo "=== CONFIGURING GUARD DUTY ==="
    
    init_log
    echo "[+] Log file initialized"
    
    # Create alias for auto-start (optional)
    if [ -f ~/.bashrc ]; then
        if ! grep -q "ewok-guard-duty" ~/.bashrc 2>/dev/null; then
            echo ""
            echo "    To auto-start guard duty on login, add to ~/.bashrc:"
            echo '    echo "Starting Ewok Guard Duty..." && ~/ewok-guard-duty.sh monitor &'
        fi
    fi
    
    echo ""
    echo "[###] SETUP COMPLETE"
}

# Main execution
case "$MODE" in
    monitor)
        init_log
        log_event "START" "Guard duty session initiated"
        monitor_mode
        ;;
    report)
        report_mode
        ;;
    setup)
        setup_mode
        ;;
    *)
        echo "Usage: ./ewok-guard-duty.sh [monitor|report|setup]"
        echo ""
        echo "  monitor  - Continuous login monitoring"
        echo "  report   - Generate activity report"
        echo "  setup    - Configure guard duty"
        exit 1
        ;;
esac
