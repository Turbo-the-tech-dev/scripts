# Turbo Scripts

> Star Wars themed automation and utility scripts for Termux/Android

[![Status](https://img.shields.io/badge/status-production-green)]()
[![Scripts](https://img.shields.io/badge/scripts-16-blue)]()
[![License](https://img.shields.io/badge/license-MIT-yellow)]()

---

## Quick Start

```bash
# Clone the repository
git clone https://github.com/Turbo-the-tech-dev/scripts.git
cd scripts

# Make all scripts executable
chmod +x *.sh scripts/**/*.sh

# List available scripts
ls -1 *.sh
```

---

## Directory Structure

```
scripts/
├── README.md                 # This file
├── *.sh                      # Main scripts (16 total)
├── scripts/                  # Utility & template scripts
│   ├── create-all-docs.sh    # Documentation generator
│   ├── generate-docs.sh      # Legacy doc generator
│   └── template.sh           # Base template for new scripts
├── {script-name}/            # Documentation per script
│   ├── README.md             # Detailed usage guide
│   ├── {script-name}.sh      # Copy of script
│   └── scripts/
│       └── template.sh       # Extension template
└── docs/                     # Additional documentation (TODO)
```

---

## Available Scripts

### 🚀 Deployment & Git

| Script | Description | Priority |
|--------|-------------|----------|
| [**bootstrap-repo**](bootstrap-repo/) | One-shot GitHub repo creation with dry-run | 🔴 HIGH |
| [**create-world-words**](create-world-words/) | Generate 47 country word directories | 🔴 HIGH |
| [**force-push**](force-push/) | Git deployment automation | 🔴 HIGH |
| [**repo-rename**](repo-rename/) | Batch GitHub repository renamer | 🟡 MEDIUM |

### 🎓 Education & Training

| Script | Description | Priority |
|--------|-------------|----------|
| [**power-forge**](power-forge/) | ICS/SCADA training environment (377 dirs) | 🔴 HIGH |
| [**scada-gen**](scada-gen/) | SCADA config generator (SEL, AB, Modbus) | 🔴 HIGH |
| [**emperor-find**](emperor-find/) | Interactive grep/awk/sed teacher (Vader) | 🟡 MEDIUM |

### 🔒 Security & Monitoring

| Script | Description | Priority |
|--------|-------------|----------|
| [**at-st-patrol**](at-st-patrol/) | Security scanner (SUID, world-writable) | 🔴 HIGH |
| [**ewok-guard-duty**](ewok-guard-duty/) | Login audit & perimeter defense | 🟡 MEDIUM |
| [**ewok-scout**](ewok-scout/) | System resource monitoring | 🟡 MEDIUM |

### 🛠️ Utilities

| Script | Description | Priority |
|--------|-------------|----------|
| [**r2d2-repair-bay**](r2d2-repair-bay/) | Dependency repair automation | 🔴 HIGH |
| [**master-cat**](master-cat/) | Directory to Markdown flattener | 🟡 MEDIUM |
| [**c3po-translator**](c3po-translator/) | Translation with JSON output | 🟢 LOW |
| [**super-cat-archive**](super-cat-archive/) | Timestamped file snapshots | 🟢 LOW |

### 🎉 Fun & Testing

| Script | Description | Priority |
|--------|-------------|----------|
| [**kylo-temper-tantrum**](kylo-temper-tantrum/) | CPU/memory stress tester | 🟡 MEDIUM |
| [**ewok-victory-dance**](ewok-victory-dance/) | Celebration with ASCII art | 🟢 LOW |

---

## Installation

### Termux (Android)

```bash
# Update packages
pkg update && pkg upgrade

# Install dependencies
pkg install git gh bash coreutils findutils

# Authenticate GitHub
gh auth login

# Clone scripts
git clone https://github.com/Turbo-the-tech-dev/scripts.git
cd scripts
chmod +x *.sh
```

### Linux/macOS

```bash
# Install GitHub CLI
# macOS: brew install gh
# Linux: sudo apt install gh

# Authenticate
gh auth login

# Clone and setup
git clone https://github.com/Turbo-the-tech-dev/scripts.git
cd scripts
chmod +x *.sh
```

---

## Usage Examples

### Create a New Repository

```bash
# Dry run first
./bootstrap-repo.sh my-project --dry-run

# Create the repo
./bootstrap-repo.sh my-project

# Verify
gh repo view my-project
```

### Monitor System Resources

```bash
./ewok-scout.sh
```

### Security Scan

```bash
./at-st-patrol.sh
```

### Generate Documentation

```bash
# For all scripts
./scripts/create-all-docs.sh

# For single script
./scripts/generate-docs.sh
```

---

## Script Templates

### Create New Script

```bash
# Copy template
cp scripts/template.sh my-new-script.sh
chmod +x my-new-script.sh

# Edit with your logic
nano my-new-script.sh
```

### Template Structure

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
NC='\033[0m'

# Helper functions
log_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $1"; }

# Main function
main() {
    log_info "Starting..."
    # Your logic here
    log_success "Complete!"
}

main "$@"
```

---

## Sandbox Testing

All scripts are tested before deployment:

| Test Type | Command | Status |
|-----------|---------|--------|
| Syntax Check | `bash -n script.sh` | ✅ All Pass |
| File Exists | `test -f script.sh` | ✅ All Pass |
| Executable | `chmod +x script.sh` | ✅ All Pass |
| Dry Run | Script-specific | ✅ All Pass |

---

## Related Repositories

| Repo | Description |
|------|-------------|
| [words](https://github.com/Turbo-the-tech-dev/words) | World vocabulary - 47 countries, 60+ languages |
| [qwen](https://github.com/Turbo-the-tech-dev/qwen) | Qwen conversation exports |

---

## Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| `Permission denied` | `chmod +x script.sh` |
| `gh: command not found` | `pkg install gh` then `gh auth login` |
| `bash: not found` | `pkg install bash` |
| Script fails silently | Run with `bash -x script.sh` for debug |

### Debug Mode

```bash
# Enable debug output
bash -x ./script.sh

# Or add to script
set -x  # Enable debugging
# ... your code ...
set +x  # Disable debugging
```

---

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

```bash
git checkout -b feature/new-script
# Make changes
git commit -m "Add new script: feature-name"
git push origin feature/new-script
```

---

## License

MIT License - See [LICENSE](LICENSE) file.

---

## Acknowledgments

- Star Wars universe for character inspiration
- Termux community for Android Linux tools
- GitHub CLI team for automation capabilities

---

**Created:** 2026-02-23  
**Version:** 1.0.0  
**Status:** ✅ Production Ready
