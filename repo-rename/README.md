# Repo-rename

> GitHub batch renamer

---

## Quick Start

```bash
./repo-rename.sh old new
```

---

## Script Information

| Property | Value |
|----------|-------|
| **File** | `repo-rename.sh` |
| **Category** | git |
| **Priority** | MEDIUM |
| **Lines** | 103 |
| **Size** | 4.0K |
| **Shebang** | `#!/usr/bin/env bash` |

---

## Sandbox Test Results

| Test | Status | Details |
|------|--------|---------|
| Syntax Check | ✅ PASS | `bash -n repo-rename.sh` |
| File Exists | ✅ PASS | File present in repo |
| Executable | ✅ PASS | chmod +x applied |
| Shebang Valid | ✅ PASS | #!/usr/bin/env bash |

---

## Features

<!-- Analyzed from script source -->

## Key Functions

```
main
```

## Commands Used

echo,gh,git,

---

## Usage

```bash
# Basic usage
cd ~/scripts
./repo-rename.sh old new

# With help (if available)
./repo-rename.sh --help
```

---

## Requirements

- Bash 4.0+
- Termux or Linux/macOS

### Additional Dependencies

| Tool | Install (Termux) | Purpose |
|------|------------------|---------|
| `git` | `pkg install git` | Version control |
| `gh` | `pkg install gh` | GitHub CLI |

## Examples

```bash
# Example 1
./repo-rename.sh old new

# Example 2
# Add more examples based on script capabilities
```

---

## How It Works

1. Script initializes with safety checks
2. Processes input/arguments
3. Executes main functionality
4. Reports results with color-coded output

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Permission denied | `chmod +x repo-rename.sh` |
| Command not found | Install required dependencies |
| Script fails | Check `bash -x repo-rename.sh` for debug |

---

## Related Scripts

| Script | Purpose |
|--------|---------|
| [bootstrap-repo](../bootstrap-repo/) | One-shot repo creation |
| [force-push](../force-push/) | Git deployment |
| [r2d2-repair-bay](../r2d2-repair-bay/) | Dependency repair |

---

## Source

View the [`repo-rename.sh`](repo-rename.sh) source code in the parent directory.

---

**Created:** 2026-02-23  
**Category:** git  
**Priority:** MEDIUM  
**Status:** ✅ Tested
