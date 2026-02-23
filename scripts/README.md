# Scripts Development Templates

Utility scripts and templates for extending the Turbo Scripts collection.

---

## Available Templates

| File | Purpose |
|------|---------|
| `template.sh` | Base template for new scripts |
| `create-all-docs.sh` | Generate documentation for all scripts |
| `generate-docs.sh` | Legacy documentation generator |

---

## Create New Script

### Step 1: Copy Template

```bash
cp scripts/template.sh my-new-script.sh
chmod +x my-new-script.sh
```

### Step 2: Edit Script

```bash
nano my-new-script.sh
```

### Step 3: Update Header

```bash
#!/bin/bash
#===============================================================================
# MY NEW SCRIPT
# Description of what the script does
#===============================================================================
```

### Step 4: Test

```bash
bash -n my-new-script.sh  # Syntax check
./my-new-script.sh        # Run test
```

### Step 5: Create Documentation

```bash
mkdir -p my-new-script
cp my-new-script.sh my-new-script/
# Run doc generator
./scripts/create-all-docs.sh
```

---

## Template: Basic Script

```bash
#!/bin/bash
#===============================================================================
# SCRIPT NAME
# Description here
#===============================================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Helper functions
log_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $1"; }
log_step()    { echo -e "${CYAN}[STEP]${NC} $1"; }

# Cleanup on exit
cleanup() {
    log_info "Cleaning up..."
}
trap cleanup EXIT

# Main function
main() {
    log_info "Starting..."
    
    # Your logic here
    
    log_success "Complete!"
}

main "$@"
```

---

## Template: Script with Arguments

```bash
#!/bin/bash
#===============================================================================
# SCRIPT WITH ARGS
#===============================================================================

set -euo pipefail

# Defaults
VERBOSE=false
OUTPUT_DIR="./output"

# Usage
usage() {
    cat <<EOF
Usage: $0 [OPTIONS] <input>

Options:
    -h, --help      Show this help
    -v, --verbose   Enable verbose output
    -o, --output    Output directory (default: ./output)

Arguments:
    input           Input file or directory
EOF
    exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -o|--output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        *)
            INPUT="$1"
            shift
            ;;
    esac
done

# Validate
if [[ -z "${INPUT:-}" ]]; then
    echo "Error: Input required"
    usage
fi

# Main
main() {
    echo "Input: $INPUT"
    echo "Output: $OUTPUT_DIR"
    echo "Verbose: $VERBOSE"
}

main
```

---

## Template: Git Integration

```bash
#!/bin/bash
#===============================================================================
# GIT INTEGRATION SCRIPT
#===============================================================================

set -euo pipefail

# Check dependencies
check_deps() {
    local missing=()
    for cmd in git gh; do
        command -v "$cmd" &>/dev/null || missing+=("$cmd")
    done
    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "Missing: ${missing[*]}"
        exit 1
    fi
}

# Git config
setup_git() {
    git config user.name "Your Name"
    git config user.email "you@example.com"
}

# Main
main() {
    check_deps
    setup_git
    # Git operations here
}

main
```

---

## Documentation Generator Usage

### Generate All Docs

```bash
./scripts/create-all-docs.sh
```

### Output Structure

```
scripts/
├── {script-name}/
│   ├── README.md           # Detailed documentation
│   ├── {script-name}.sh    # Script copy
│   └── scripts/
│       └── template.sh     # Extension template
```

### README Contents

Each generated README includes:
- Quick start guide
- Script information table
- Sandbox test results
- Features list
- Usage examples
- Requirements
- Troubleshooting
- Related scripts

---

## Best Practices

### Code Style

1. **Always use** `set -euo pipefail`
2. **Quote variables**: `"$var"` not `$var`
3. **Use functions** for reusability
4. **Add comments** for complex logic
5. **Color-code output** for readability

### Error Handling

```bash
# Exit on error
set -e

# Check command success
if ! command -v git &>/dev/null; then
    log_error "Git not installed"
    exit 1
fi

# Trap errors
trap 'log_error "Failed at line $LINENO"' ERR
```

### Testing

```bash
# Syntax check
bash -n script.sh

# Dry run (if supported)
./script.sh --dry-run

# Debug mode
bash -x script.sh

# ShellCheck (linting)
shellcheck script.sh
```

---

## Version Control

### Commit Message Format

```
<type>: <description>

[optional body]

[optional footer]
```

### Types

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation
- `style:` Formatting
- `refactor:` Code restructuring
- `test:` Tests
- `chore:` Maintenance

### Example

```bash
git commit -m "feat: add ewok-scout system monitoring

- CPU usage tracking
- Memory monitoring
- Battery status (Android)
- Network interface info

Closes #12"
```

---

**Created:** 2026-02-23  
**Category:** Development  
**Status:** ✅ Ready
