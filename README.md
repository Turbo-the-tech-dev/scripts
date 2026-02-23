# Turbo Scripts Collection

Star Wars themed automation and utility scripts for Termux/Android.

---

## Quick Start

```bash
git clone https://github.com/Turbo-the-tech-dev/scripts.git
cd scripts
chmod +x *.sh
```

---

## Repository Scripts

### 🚀 Deployment & Automation

| Script | Purpose |
|--------|---------|
| `bootstrap-repo.sh` | One-shot GitHub repo creation with full structure |
| `force-push.sh` | Git deployment automation |
| `repo-rename.sh` | Batch GitHub repository renamer |

### 🌍 World Words Project

| Script | Purpose |
|--------|---------|
| `create-world-words.sh` | Generate 47 country word directories with 10,000 words each |

### 🎓 Training & Education

| Script | Purpose |
|--------|---------|
| `power-forge.sh` | ICS/SCADA training environment builder (377 student directories) |
| `scada-gen.sh` | SCADA configuration generator (SEL, Allen-Bradley, Modbus) |
| `emperor-find.sh` | Interactive grep/awk/sed teaching tool (Lord Vader persona) |

### 🤖 Star Wars Utilities

| Script | Purpose |
|--------|---------|
| `ewok-guard-duty.sh` | Login auditing and perimeter defense |
| `ewok-scout.sh` | System resource monitoring (CPU, memory, battery) |
| `ewok-victory-dance.sh` | Celebration notifications with ASCII art |
| `at-st-patrol.sh` | Security scanning (world-writable files, SUID, processes) |
| `kylo-temper-tantrum.sh` | CPU/memory stress testing |
| `c3po-translator.sh` | Translation protocol with JSON output |
| `r2d2-repair-bay.sh` | Dependency repair and environment setup |

### 📦 Archive Tools

| Script | Purpose |
|--------|---------|
| `master-cat.sh` | Directory flattening into Markdown |
| `super-cat-archive.sh` | Grand Archive Protocol implementation |

---

## Usage Examples

```bash
# Create a new repo
./bootstrap-repo.sh my-project

# Monitor system resources
./ewok-scout.sh

# Security scan
./at-st-patrol.sh

# Create SCADA configs
./scada-gen.sh

# Stress test
./kylo-temper-tantrum.sh high
```

---

## Requirements

- Termux (Android) or Linux/macOS terminal
- Git
- GitHub CLI (`gh`)
- Bash 4.0+

---

## Installation

```bash
# Install dependencies (Termux)
pkg install git gh bash

# Clone and setup
git clone https://github.com/Turbo-the-tech-dev/scripts.git
cd scripts
chmod +x *.sh
```

---

## Related Repos

| Repo | Description |
|------|-------------|
| [words](https://github.com/Turbo-the-tech-dev/words) | World vocabulary - 47 countries, 60+ languages |
| [qwen](https://github.com/Turbo-the-tech-dev/qwen) | Qwen conversation exports |

---

**License:** MIT  
**Created:** 2026-02-23
