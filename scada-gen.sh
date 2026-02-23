#!/usr/bin/env bash
# =====================================================
# scada-gen.sh - SCADA Configuration Generator
# Populates SCADA directories with realistic training files
# Usage: ./scada-gen.sh [base_dir]
# =====================================================

set -e

BASE_DIR="${1:-$HOME/Institute/PowerPlant/scada}"

echo "[*] INITIALIZING SCADA CONFIG GENERATOR"
echo "    Target: $BASE_DIR"
echo ""

# Create directory structure
echo "[+] Creating SCADA subdirectories..."
mkdir -p "$BASE_DIR/configs/sel" "$BASE_DIR/configs/ab" "$BASE_DIR/configs/siemens" "$BASE_DIR/configs/misc"
mkdir -p "$BASE_DIR/plc/ladder" "$BASE_DIR/plc/structured_text" "$BASE_DIR/plc/function_block"
mkdir -p "$BASE_DIR/rtus/modbus" "$BASE_DIR/rtus/dnp3" "$BASE_DIR/rtus/iec61850"
mkdir -p "$BASE_DIR/hmi/panels" "$BASE_DIR/hmi/alarms" "$BASE_DIR/hmi/trends"

# ============================================
# PROTECTIVE RELAY CONFIGS (SEL Family)
# ============================================
echo "[+] Generating protective relay configs..."

cat > "$BASE_DIR/configs/sel/sel-421-relay.conf" << 'EOF'
# SEL-421 Relay Configuration – Training Example
# Application: Transmission Line Protection
# ============================================

# CT/VT Ratios
CTR  = 400:5        # Current Transformer ratio
PTR  = 14400:120    # Potential Transformer ratio

# Distance Protection Zones
E21  = 1            # Distance element enable
Z1DIST = 5.0        # Zone 1 reach (ohms secondary)
Z1ANG = 85.0        # Zone 1 maximum torque angle
Z2DIST = 15.0       # Zone 2 reach
Z2ANG = 85.0
Z3DIST = 30.0       # Zone 3 reach (backup)
Z3ANG = 85.0

# Time Delays
Z1TD = 0.0          # Zone 1 - instantaneous
Z2TD = 0.30         # Zone 2 - 30 cycles
Z3TD = 1.00         # Zone 3 - 60 cycles

# Overcurrent Elements
E50P = 1            # Phase instantaneous overcurrent
50P1P = 8.0         # Pickup (amps secondary)
E51P = 1            # Phase time overcurrent
51PP = 4.0          # Pickup
51PTC = U3          # Time curve: U3 (Very Inverse)

# Breaker Failure
E50BF = 1           # Breaker failure detection
50BFP = 2.0         # Pickup
50BFD = 0.15        # Timer (15 cycles)

# Output Contacts
OUT101 = TRIP       # Main trip contact
OUT102 = CLOSE      # Close contact
OUT103 = ALARM      # Alarm contact
EOF

cat > "$BASE_DIR/configs/sel/sel-351-feeder.conf" << 'EOF'
# SEL-351 Relay Configuration – Feeder Protection
# Application: Distribution Feeder (13.8kV)
# =============================================

# System Configuration
PHROT = ABC         # Phase rotation
FREQ = 60.0         # System frequency (Hz)

# CT/VT Ratios
CTR = 600:5
PTR = 14400:120

# Phase Overcurrent
50P1P = 10.0        # Instantaneous pickup
51PP = 5.0          # Time overcurrent pickup
51PTC = U1          # Moderately inverse curve

# Ground Overcurrent
50G1P = 2.0         # Instantaneous ground
51GP = 1.0          # Time ground pickup
51GTC = U1          # Moderately inverse

# Reclosing
E79 = 1             # Recloser enable
79CLS = 1           # Close pulse duration
79R1 = 0.5          # First shot delay (sec)
79R2 = 2.0          # Second shot delay
79R3 = 10.0         # Third shot delay
79NOS = 4           # Number of shots

# Sync Check
25 = 1              # Sync check enable
25ANG = 25          # Angle difference limit
25V = 0.9           # Voltage difference limit
EOF

cat > "$BASE_DIR/configs/sel/sel-751-motor.conf" << 'EOF'
# SEL-751 Relay Configuration – Motor Protection
# Application: 5000 HP Induction Motor
# ============================================

# Motor Nameplate
MOTOR_HP = 5000
MOTOR_KV = 13.8
MOTOR_FLA = 185       # Full load amps (primary)
MOTOR_LRA = 1110      # Locked rotor amps
SF = 1.15             # Service factor

# CT Ratios
CTR = 200:5

# Thermal Overload
49 = 1                # Thermal element enable
THERMAL_TC = 30       # Thermal capacity (minutes)
49TRIP = 100          # Trip threshold (%)

# Overcurrent
50P1P = 12.0          # Instantaneous (above LRA)
51PP = 2.5            # Time overcurrent pickup
51PTC = M2            # Motor curve

# Undercurrent (Loss of Load)
37P = 1.0             # Pickup (amps secondary)
37D = 5.0             # Delay (seconds)

# Negative Sequence (Unbalance)
46Q = 1               # Enable
46Q1P = 0.5           # Pickup
46Q1D = 10.0          # Delay

# Starts Per Hour
66 = 2                # Max starts per hour
66TIME = 30           # Start time limit (sec)
EOF

# ============================================
# PLC CONFIGS (Allen-Bradley / Rockwell)
# ============================================
echo "[+] Generating PLC configurations..."

cat > "$BASE_DIR/configs/ab/compactlogix-power.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!-- Allen-Bradley CompactLogix - Power Monitoring Application -->
<!-- Training Example - Not for production use -->
<Controller Name="PowerPlant_MCC" Revision="32" Vendor="Rockwell Automation">
  
  <!-- Tags Database -->
  <Tags>
    <Tag Name="MainBus_Voltage" DataType="REAL" Address="Local:1:I.Data0"/>
    <Tag Name="MainBus_Current" DataType="REAL" Address="Local:1:I.Data1"/>
    <Tag Name="MainBus_Freq" DataType="REAL" Address="Local:1:I.Data2"/>
    <Tag Name="MainBus_kW" DataType="REAL" Address="Local:1:I.Data3"/>
    <Tag Name="MainBus_kVAR" DataType="REAL" Address="Local:1:I.Data4"/>
    <Tag Name="MainBus_PF" DataType="REAL" Address="Local:1:I.Data5"/>
    
    <!-- Breaker Status -->
    <Tag Name="Breaker_52_1_Close" DataType="BOOL" Address="Local:2:O.Data0"/>
    <Tag Name="Breaker_52_1_Trip" DataType="BOOL" Address="Local:2:O.Data1"/>
    <Tag Name="Breaker_52_1_Status" DataType="BOOL" Address="Local:2:I.Data0"/>
    
    <!-- Alarms -->
    <Tag Name="Alarm_OverVoltage" DataType="BOOL"/>
    <Tag Name="Alarm_UnderVoltage" DataType="BOOL"/>
    <Tag Name="Alarm_OverCurrent" DataType="BOOL"/>
    <Tag Name="Alarm_OverFreq" DataType="BOOL"/>
    
    <!-- Setpoints -->
    <Tag Name="Setpoint_Voltage_Hi" DataType="REAL" InitialValue="504.0"/>
    <Tag Name="Setpoint_Voltage_Lo" DataType="REAL" InitialValue="456.0"/>
    <Tag Name="Setpoint_Current_Max" DataType="REAL" InitialValue="4200.0"/>
    <Tag Name="Setpoint_Freq_Hi" DataType="REAL" InitialValue="61.5"/>
    <Tag Name="Setpoint_Freq_Lo" DataType="REAL" InitialValue="58.5"/>
  </Tags>
  
  <!-- Ladder Logic Rungs (Structured Text representation) -->
  <Program Name="PowerMonitoring">
    <Routine Name="Main" Type="Ladder">
      <![CDATA[
      // Rung 0: Overvoltage Detection
      IF MainBus_Voltage > Setpoint_Voltage_Hi THEN
        Alarm_OverVoltage := TRUE;
        Breaker_52_1_Trip := TRUE;
      END_IF;
      
      // Rung 1: Undervoltage Detection
      IF MainBus_Voltage < Setpoint_Voltage_Lo THEN
        Alarm_UnderVoltage := TRUE;
      END_IF;
      
      // Rung 2: Overcurrent Detection
      IF MainBus_Current > Setpoint_Current_Max THEN
        Alarm_OverCurrent := TRUE;
        TON_Timer_Overcurrent(IN := TRUE, PT := T#3S);
        IF TON_Timer_Overcurrent.Q THEN
          Breaker_52_1_Trip := TRUE;
        END_IF;
      END_IF;
      
      // Rung 3: Breaker Close Command (with permissives)
      IF NOT Alarm_OverVoltage AND NOT Alarm_UnderVoltage 
         AND NOT Alarm_OverCurrent AND Breaker_52_1_Status = FALSE THEN
        Breaker_52_1_Close := TRUE;
      END_IF;
      ]]>
    </Routine>
  </Program>
</Controller>
EOF

cat > "$BASE_DIR/configs/ab/i-o-configuration.csv" << 'EOF'
Slot,Module,Type,Address,Description
0,1769-L33E,CPU,Local:0:,CompactLogix L33E Processor
1,1769-IR6,Analog Input,Local:1:I,6-Channel RTD/Resistance
2,1769-OB16,Digital Output,Local:2:O,16-Point 24VDC Output
3,1769-IB16,Digital Input,Local:3:I,16-Point 24VDC Input
4,1769-OF4,Analog Output,Local:4:O,4-Channel Analog Output
EOF

# ============================================
# MODBUS RTU REGISTER MAPS
# ============================================
echo "[+] Generating RTU configurations..."

cat > "$BASE_DIR/rtus/modbus/modbus-register-map.csv" << 'EOF'
Register,Description,Type,Units,Access,Scale
40001,Voltage L1-N,float,V,RO,0.1
40002,Voltage L2-N,float,V,RO,0.1
40003,Voltage L3-N,float,V,RO,0.1
40004,Voltage L1-L2,float,V,RO,0.1
40005,Voltage L2-L3,float,V,RO,0.1
40006,Voltage L3-L1,float,V,RO,0.1
40007,Current L1,float,A,RO,0.001
40008,Current L2,float,A,RO,0.001
40009,Current L3,float,A,RO,0.001
40010,Neutral Current,float,A,RO,0.001
40011,Frequency,float,Hz,RO,0.01
40012,Real Power Total,float,kW,RO,0.1
40013,Reactive Power Total,float,kVAR,RO,0.1
40014,Apparent Power Total,float,kVA,RO,0.1
40015,Power Factor,float,pf,RO,0.001
40016,Real Energy Import,float,kWh,RO,0.1
40017,Real Energy Export,float,kWh,RO,0.1
40018,Breaker 52-1 Status,boolean,,RO,1=Closed
40019,Breaker 52-2 Status,boolean,,RO,1=Closed
40020,Alarm Status,uint16,,RO,Bitmask
40021,Control Register,uint16,,RW,Bitmask
40022,Breaker 52-1 Command,boolean,,RW,1=Close
40023,Breaker 52-1 Trip,boolean,,RW,1=Trip
40024,Alarm Reset,boolean,,WO,1=Reset
EOF

cat > "$BASE_DIR/rtus/modbus/alarm-bitmask.txt" << 'EOF'
# Modbus Register 40020 - Alarm Status Bitmask
# =============================================
# Bit 0: Overvoltage L1
# Bit 1: Overvoltage L2
# Bit 2: Overvoltage L3
# Bit 3: Undervoltage L1
# Bit 4: Undervoltage L2
# Bit 5: Undervoltage L3
# Bit 6: Overcurrent L1
# Bit 7: Overcurrent L2
# Bit 8: Overcurrent L3
# Bit 9: Overfrequency
# Bit 10: Underfrequency
# Bit 11: Reverse Power
# Bit 12: Breaker Fail
# Bit 13: Communications Loss
# Bit 14: Ground Fault
# Bit 15: Reserved
EOF

cat > "$BASE_DIR/rtus/modbus/control-bitmask.txt" << 'EOF'
# Modbus Register 40021 - Control Register Bitmask
# =================================================
# Bit 0: Breaker 52-1 Close Enable
# Bit 1: Breaker 52-1 Trip Enable
# Bit 2: Breaker 52-2 Close Enable
# Bit 3: Breaker 52-2 Trip Enable
# Bit 4: Auto Reclose Enable
# Bit 5: Sync Check Bypass
# Bit 6: Local/Remote (0=Local, 1=Remote)
# Bit 7: Alarm Silence
# Bit 8-15: Reserved
EOF

# ============================================
# DNP3 POINT DATABASE
# ============================================
echo "[+] Generating DNP3 configurations..."

cat > "$BASE_DIR/rtus/dnp3/dnp3-point-list.csv" << 'EOF'
Index,Group,Variation,Description,Type,Class
0,30,1,Voltage L1-N,Analog Input,1
1,30,1,Voltage L2-N,Analog Input,1
2,30,1,Voltage L3-N,Analog Input,1
3,30,1,Current L1,Analog Input,2
4,30,1,Current L2,Analog Input,2
5,30,1,Current L3,Analog Input,2
6,30,1,Frequency,Analog Input,1
7,30,1,Real Power Total,Analog Input,1
8,30,1,Reactive Power Total,Analog Input,1
9,30,1,Power Factor,Analog Input,1
10,1,2,Breaker 52-1 Status,Binary Input,1
11,1,2,Breaker 52-2 Status,Binary Input,1
12,2,1,Alarm Overvoltage,Binary Input,2
13,2,1,Alarm Undervoltage,Binary Input,2
14,2,1,Alarm Overcurrent,Binary Input,2
15,12,1,Breaker 52-1 Close,Binary Output,1
16,12,1,Breaker 52-1 Trip,Binary Output,1
17,40,2,Breaker 52-1 Command,Analog Output,1
EOF

# ============================================
# HMI CONFIGURATIONS
# ============================================
echo "[+] Generating HMI configurations..."

cat > "$BASE_DIR/hmi/panels/main-switchboard.json" << 'EOF'
{
  "panel_id": "MSB-01",
  "panel_name": "Main Switchboard",
  "voltage_level": "480V",
  "created": "2026-02-22",
  "elements": [
    {
      "id": "meter_001",
      "type": "digital_meter",
      "label": "Voltage L1-N",
      "position": {"x": 100, "y": 50},
      "source": "modbus://1:40001",
      "units": "V",
      "scale": 0.1,
      "alarm_hi": 277.2,
      "alarm_lo": 249.3
    },
    {
      "id": "meter_002",
      "type": "digital_meter",
      "label": "Current L1",
      "position": {"x": 100, "y": 100},
      "source": "modbus://1:40007",
      "units": "A",
      "scale": 0.001,
      "alarm_hi": 4200
    },
    {
      "id": "meter_003",
      "type": "digital_meter",
      "label": "Frequency",
      "position": {"x": 100, "y": 150},
      "source": "modbus://1:40011",
      "units": "Hz",
      "scale": 0.01,
      "alarm_hi": 61.5,
      "alarm_lo": 58.5
    },
    {
      "id": "breaker_001",
      "type": "breaker_indicator",
      "label": "Breaker 52-1",
      "position": {"x": 300, "y": 100},
      "status_source": "modbus://1:40018",
      "close_cmd": "modbus://1:40022",
      "trip_cmd": "modbus://1:40023",
      "permissives": ["!Alarm_Overvoltage", "!Alarm_Undervoltage"]
    },
    {
      "id": "alarm_001",
      "type": "alarm_banner",
      "position": {"x": 0, "y": 0},
      "source": "modbus://1:40020",
      "format": "bitmask",
      "mapping": "alarms/alarm-bitmap.json"
    }
  ]
}
EOF

cat > "$BASE_DIR/hmi/alarms/alarm-definitions.json" << 'EOF'
{
  "alarms": [
    {
      "id": "ALM_001",
      "name": "Overvoltage L1",
      "severity": "critical",
      "condition": "Voltage_L1N > 277.2",
      "delay_sec": 0,
      "action": ["trip_breaker_52_1", "log_event"]
    },
    {
      "id": "ALM_002",
      "name": "Undervoltage L1",
      "severity": "warning",
      "condition": "Voltage_L1N < 249.3",
      "delay_sec": 5,
      "action": ["log_event"]
    },
    {
      "id": "ALM_003",
      "name": "Overcurrent L1",
      "severity": "critical",
      "condition": "Current_L1 > 4200",
      "delay_sec": 3,
      "action": ["trip_breaker_52_1", "log_event"]
    },
    {
      "id": "ALM_004",
      "name": "Overfrequency",
      "severity": "warning",
      "condition": "Frequency > 61.5",
      "delay_sec": 2,
      "action": ["log_event"]
    },
    {
      "id": "ALM_005",
      "name": "Underfrequency",
      "severity": "critical",
      "condition": "Frequency < 58.5",
      "delay_sec": 1,
      "action": ["trip_breaker_52_1", "log_event"]
    },
    {
      "id": "ALM_006",
      "name": "Breaker Fail",
      "severity": "critical",
      "condition": "Trip_Command AND NOT Breaker_Open",
      "delay_sec": 0.5,
      "action": ["trip_upstream", "log_event"]
    }
  ]
}
EOF

cat > "$BASE_DIR/hmi/trends/trend-config.json" << 'EOF'
{
  "trends": [
    {
      "id": "trend_001",
      "name": "Voltage Trends",
      "duration_min": 60,
      "interval_sec": 1,
      "pens": [
        {"tag": "Voltage_L1N", "color": "red"},
        {"tag": "Voltage_L2N", "color": "yellow"},
        {"tag": "Voltage_L3N", "color": "blue"}
      ]
    },
    {
      "id": "trend_002",
      "name": "Current Trends",
      "duration_min": 60,
      "interval_sec": 1,
      "pens": [
        {"tag": "Current_L1", "color": "red"},
        {"tag": "Current_L2", "color": "yellow"},
        {"tag": "Current_L3", "color": "blue"}
      ]
    },
    {
      "id": "trend_003",
      "name": "Power Trends",
      "duration_min": 1440,
      "interval_sec": 60,
      "pens": [
        {"tag": "Real_Power_kW", "color": "green"},
        {"tag": "Reactive_Power_kVAR", "color": "orange"}
      ]
    }
  ]
}
EOF

# ============================================
# SIEMENS CONFIGS
# ============================================
echo "[+] Generating Siemens configs..."

cat > "$BASE_DIR/configs/siemens/s7-1200-power.db" << 'EOF'
// Siemens S7-1200 Power Monitoring - Data Block
// Training Example - Not for production

DATA_BLOCK "PowerMonitoring"
STRUCT
  // Analog Inputs
  Voltage_L1N : Real := 0.0;
  Voltage_L2N : Real := 0.0;
  Voltage_L3N : Real := 0.0;
  Current_L1 : Real := 0.0;
  Current_L2 : Real := 0.0;
  Current_L3 : Real := 0.0;
  Frequency : Real := 0.0;
  Real_Power : Real := 0.0;
  Reactive_Power : Real := 0.0;
  
  // Digital Inputs
  Breaker_52_1_Status : Bool := FALSE;
  Breaker_52_2_Status : Bool := FALSE;
  Remote_Command : Bool := FALSE;
  
  // Alarms
  Alarm_Overvoltage : Bool := FALSE;
  Alarm_Undervoltage : Bool := FALSE;
  Alarm_Overcurrent : Bool := FALSE;
  
  // Outputs
  Breaker_52_1_Close : Bool := FALSE;
  Breaker_52_1_Trip : Bool := FALSE;
  Alarm_Reset : Bool := FALSE;
  
  // Parameters
  Setpoint_V_Hi : Real := 277.2;
  Setpoint_V_Lo : Real := 249.3;
  Setpoint_I_Max : Real := 4200.0;
END_STRUCT
END_DATA_BLOCK
EOF

# ============================================
# SUMMARY
# ============================================
total_files=$(find "$BASE_DIR" -type f | wc -l)

echo ""
echo "[###] SCADA CONFIG GENERATION COMPLETE"
echo "    Total files created: $total_files"
echo ""
echo "Generated directories:"
echo "  - configs/sel/      : Protective relay configs (SEL-421, SEL-351, SEL-751)"
echo "  - configs/ab/       : Allen-Bradley PLC configs"
echo "  - configs/siemens/  : Siemens S7-1200 configs"
echo "  - rtus/modbus/      : Modbus register maps"
echo "  - rtus/dnp3/        : DNP3 point lists"
echo "  - hmi/panels/       : HMI panel configurations"
echo "  - hmi/alarms/       : Alarm definitions"
echo "  - hmi/trends/       : Trend configurations"
echo ""
echo "Training exercises:"
echo "  1. Review SEL-421 distance protection settings"
echo "  2. Modify PLC ladder logic for new permissives"
echo "  3. Add new Modbus registers to the map"
echo "  4. Create new HMI alarm conditions"
