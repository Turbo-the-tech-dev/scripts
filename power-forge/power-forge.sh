#!/usr/bin/env bash
# =====================================================
# power-forge.sh - POWER CORE SECTOR FORGE
# Builds full ICS/SCADA training environment
# Usage: ./power-forge.sh [num_students] [base_dir]
# =====================================================

set -e

NUM_STUDENTS="${1:-377}"
BASE_DIR="${2:-$HOME/Institute/PowerPlant}"

echo "[*] INITIALIZING POWER CORE FORGE"
echo "    Students: $NUM_STUDENTS"
echo "    Base: $BASE_DIR"
echo ""

# Create full ICS/SCADA structure
echo "[+] Building sector directories..."
mkdir -p "$BASE_DIR"/{scada/{configs,hmi,plc,rtus},monitoring/{logs,dashboards,alerts},backups/{daily,archives},documentation/{runbooks,diagrams,compliance},users/{operators,engineers,admins},historian,security}

# Create 377 student directories
echo "[+] Creating $NUM_STUDENTS student directories..."
mkdir -p "$BASE_DIR/students"
for i in $(seq 1 $NUM_STUDENTS); do
    student_id=$(printf "%03d" $i)
    mkdir -p "$BASE_DIR/students/student_$student_id"
    
    # Create student README template
    cat > "$BASE_DIR/students/student_$student_id/README.md" << EOF
# Student $student_id

## Assigned Projects
- [ ] SCADA Configuration Module
- [ ] PLC Programming Exercise
- [ ] HMI Design Project

## Completed Work
| Date | Module | Status |
|------|--------|--------|
| | | |

## Notes
_Add your notes here_
EOF
done

# Secure permissions (NERC-CIP style)
echo "[+] Setting security permissions..."
find "$BASE_DIR" -type d -exec chmod 750 {} \;
find "$BASE_DIR" -type f -exec chmod 640 {} \;
chmod 700 "$BASE_DIR/security"
chmod 700 "$BASE_DIR/backups"
chmod 755 "$BASE_DIR/students"

# Link existing Kylo Arsenal tools
echo "[+] Linking Kylo Arsenal tools..."
if [ -f "$HOME/Kylo/scripts/ewok-scout.sh" ]; then
    ln -sf "$HOME/Kylo/scripts/ewok-scout.sh" "$BASE_DIR/monitoring/"
fi
if [ -f "$HOME/Kylo/scripts/force-push.sh" ]; then
    ln -sf "$HOME/Kylo/scripts/force-push.sh" "$BASE_DIR/"
fi
if [ -f "$HOME/Kylo/scripts/ewok-guard-duty.sh" ]; then
    ln -sf "$HOME/Kylo/scripts/ewok-guard-duty.sh" "$BASE_DIR/security/"
fi

# Create compliance documentation
echo "[+] Generating compliance templates..."
cat > "$BASE_DIR/documentation/compliance/NERC-CIP-005.md" << 'EOF'
# NERC CIP-005 – Electronic Security Perimeter

## Requirements
- [ ] All SCADA access via VPN only
- [ ] No direct internet on PLC networks
- [ ] Audited by ewok-guard-duty.sh
- [ ] Monthly access reviews

## Access Control Matrix
| Role | SCADA | Historian | Monitoring | Backups |
|------|-------|-----------|------------|---------|
| Operator | Read | Read | Read | No |
| Engineer | Read/Write | Read/Write | Full | Read |
| Admin | Full | Full | Full | Full |

## Audit Log Location
`$BASE_DIR/security/audit.log`
EOF

cat > "$BASE_DIR/documentation/runbooks/scada-overload-response.md" << 'EOF'
# SCADA Overload Response Runbook

## Symptoms
- High CPU on SCADA server
- Slow HMI response
- Delayed telemetry updates

## Immediate Actions
1. Run `./monitoring/ewok-scout.sh 1` for real-time stats
2. Check `./monitoring/logs/scada.log` for errors
3. If overload confirmed, execute `./scripts/maintenance/restart-scada.sh`

## Escalation
- Level 1: Shift Operator
- Level 2: Control Room Engineer
- Level 3: System Admin
EOF

# Create sample electrical config files
echo "[+] Creating sample configurations..."
cat > "$BASE_DIR/scada/configs/panel-settings.conf" << 'EOF'
# SCADA Panel Configuration
# Voltage: 480V 3-Phase
# Frequency: 60Hz

[MainBreaker]
rating_amps=4000
trip_curve=LSI
coordination=selective

[Feeder1]
load_type=Motor
hp=50
voltage=480
phase=3

[Feeder2]
load_type=Lighting
amps=200
voltage=277
EOF

cat > "$BASE_DIR/historian/tags.csv" << 'EOF'
tag_id,description,unit,engineering_units_min,engineering_units_max
PT_101,Main Bus Voltage,V,0,600
CT_101,Main Feeder Current,A,0,5000
KW_101,Real Power,kW,0,5000
KVAR_101,Reactive Power,kVAR,0,3000
HZ_101,Frequency,Hz,55,65
EOF

# Generate master index
echo "[+] Building master index..."
cat > "$BASE_DIR/INDEX.md" << EOF
# Power Plant Training Institute

**Generated:** $(date)
**Students:** $NUM_STUDENTS
**Security Level:** NERC CIP Compliant

## Directory Map

| Sector | Path | Purpose |
|--------|------|---------|
| SCADA | scada/ | Control system configs |
| Monitoring | monitoring/ | Real-time telemetry |
| Historian | historian/ | Data archival |
| Backups | backups/ | Isolated snapshots |
| Students | students/ | $NUM_STUDENTS trainee directories |
| Compliance | documentation/compliance/ | NERC CIP docs |

## Quick Commands
\`\`\`bash
./monitoring/ewok-scout.sh 5      # Real-time monitoring
./security/ewok-guard-duty.sh     # Login auditing
./force-push.sh                   # Deploy changes
\`\`\`

## Security Notes
- RBAC enforced at filesystem level
- Backups isolated from production
- All access logged to security/audit.log
EOF

# Count results
total_dirs=$(find "$BASE_DIR" -type d | wc -l)
total_files=$(find "$BASE_DIR" -type f | wc -l)

echo ""
echo "[###] POWER CORE FORGE COMPLETE"
echo "    Total Directories: $total_dirs"
echo "    Total Files: $total_files"
echo "    Student Directories: $NUM_STUDENTS"
echo ""
echo "    Location: $BASE_DIR"
echo ""
echo "Next Steps:"
echo "  1. cd $BASE_DIR"
echo "  2. Review INDEX.md"
echo "  3. Assign students to directories"
echo "  4. Run ./monitoring/ewok-scout.sh to begin"
