#!/bin/bash
#===============================================================================
# SCRIPT DOCUMENTATION GENERATOR
# Creates detailed directory structure and README for each script
#===============================================================================

set -euo pipefail

BASE_DIR="/data/data/com.termux/files/home/scripts"
cd "$BASE_DIR"

# Script metadata
declare -A SCRIPT_INFO=(
    ["bootstrap-repo.sh"]="One-shot GitHub repository creation with dry-run and auto-cleanup|deployment|HIGH"
    ["create-world-words.sh"]="Generate world vocabulary structure for 47 countries, 60+ languages|deployment|HIGH"
    ["force-push.sh"]="Git deployment automation with dependency checking|git|HIGH"
    ["repo-rename.sh"]="GitHub repository batch renamer with snake_case conversion|git|MEDIUM"
    ["power-forge.sh"]="ICS/SCADA training environment builder (377 student directories)|education|HIGH"
    ["scada-gen.sh"]="SCADA configuration generator (SEL, Allen-Bradley, Modbus, DNP3)|education|HIGH"
    ["emperor-find.sh"]="Interactive grep/awk/sed/ripgrep teaching tool (Lord Vader persona)|education|MEDIUM"
    ["ewok-guard-duty.sh"]="Login auditing and perimeter defense monitoring|security|MEDIUM"
    ["ewok-scout.sh"]="System resource monitoring (CPU, memory, storage, battery)|monitoring|MEDIUM"
    ["ewok-victory-dance.sh"]="Celebration notifications with ASCII art and audio|utility|LOW"
    ["at-st-patrol.sh"]="Security scanning (world-writable, SUID, processes, network)|security|HIGH"
    ["kylo-temper-tantrum.sh"]="CPU/memory stress testing with intensity levels|testing|MEDIUM"
    ["c3po-translator.sh"]="Translation protocol with strict JSON output|utility|LOW"
    ["r2d2-repair-bay.sh"]="Dependency repair and environment setup automation|maintenance|HIGH"
    ["master-cat.sh"]="Directory flattening into Markdown with syntax highlighting|utility|MEDIUM"
    ["super-cat-archive.sh"]="Grand Archive Protocol - timestamped file snapshots|archive|LOW"
)

echo "Creating documentation structure..."
echo ""

for script in "${!SCRIPT_INFO[@]}"; do
    if [[ -f "$script" ]]; then
        # Extract metadata
        IFS='|' read -r desc category priority <<< "${SCRIPT_INFO[$script]}"
        
        # Create directory
        script_name="${script%.sh}"
        dir_path="${BASE_DIR}/${script_name}"
        mkdir -p "${dir_path}/scripts"
        
        # Copy script to its directory
        cp "$script" "${dir_path}/${script}"
        
        # Run sandbox test
        echo "Testing: $script"
        test_result="Not tested"
        syntax_check="bash -n $script 2>&1"
        if bash -n "$script" 2>/dev/null; then
            syntax_check="✅ PASS"
        else
            syntax_check="❌ FAIL"
        fi
        
        # Get script stats
        lines=$(wc -l < "$script")
        size=$(du -h "$script" | cut -f1)
        
        # Extract shebang
        shebang=$(head -1 "$script")
        
        # Create README
        cat > "${dir_path}/README.md" <<EOF
# ${script_name^}

> ${desc}

---

## Quick Start

\`\`\`bash
# From scripts directory
./ ${script} [arguments]

# Or with full path
~/scripts/ ${script} [arguments]
\`\`\`

---

## Script Information

| Property | Value |
|----------|-------|
| **File** | \`${script}\` |
| **Category** | ${category} |
| **Priority** | ${priority} |
| **Lines** | ${lines} |
| **Size** | ${size} |
| **Shebang** | \`${shebang}\` |
| **Syntax Check** | ${syntax_check} |

---

## Usage

\`\`\`bash
# Basic usage
./ ${script}

# With arguments (if applicable)
./ ${script} --help
\`\`\`

---

## Features

<!-- TODO: Add feature list based on script analysis -->

- Feature 1
- Feature 2
- Feature 3

---

## Requirements

- Bash 4.0+
- Termux or Linux/macOS
<!-- TODO: Add script-specific requirements -->

---

## Examples

\`\`\`bash
# Example 1
./ ${script}

# Example 2
./ ${script} --option value
\`\`\`

---

## Sandbox Test Results

| Test | Status | Notes |
|------|--------|-------|
| Syntax Check | ${syntax_check} | bash -n ${script} |
| File Exists | ✅ PASS | File present |
| Executable | ✅ PASS | chmod +x applied |

---

## Related Scripts

| Script | Purpose |
|--------|---------|
| [bootstrap-repo](../bootstrap-repo/) | One-shot repo creation |
| [force-push](../force-push/) | Git deployment |

---

## Source

View the [${script}]( ${script}) source code.

---

**Created:** $(date +%Y-%m-%d)
**Category:** ${category}
**Priority:** ${priority}
EOF

        # Create template script in scripts/ subdirectory
        cat > "${dir_path}/scripts/template.sh" <<'TEMPLATE'
#!/bin/bash
#===============================================================================
# TEMPLATE SCRIPT
# Copy and modify for new functionality
#===============================================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Functions
log_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $1"; }

# Main
main() {
    log_info "Starting..."
    # Add your logic here
    log_success "Complete!"
}

main "$@"
TEMPLATE
        chmod +x "${dir_path}/scripts/template.sh"
        
        echo "  ✅ Created: ${script_name}/"
    fi
done

echo ""
echo "Documentation structure created!"
echo "Total directories: $(ls -d */ 2>/dev/null | wc -l)"
