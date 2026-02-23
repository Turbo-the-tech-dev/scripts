# At-st-patrol

> Security scanner (SUID, world-writable)

---

## Quick Start

```bash
./at-st-patrol.sh
```

---

## Script Information

| Property | Value |
|----------|-------|
| **File** | `at-st-patrol.sh` |
| **Category** | security |
| **Priority** | HIGH |
| **Lines** | 119 |
| **Size** | 4.0K |
| **Shebang** | `#!/usr/bin/env bash` |

---

## Sandbox Test Results

| Test | Status | Details |
|------|--------|---------|
| Syntax Check | ✅ PASS | `bash -n at-st-patrol.sh` |
| File Exists | ✅ PASS | File present in repo |
| Executable | ✅ PASS | chmod +x applied |
| Shebang Valid | ✅ PASS | #!/usr/bin/env bash |

---

## Features

<!-- Analyzed from script source -->

## Key Functions

```
report_threat
```

## Commands Used

echo,find,grep,

---

## Usage

```bash
# Basic usage
cd ~/scripts
./at-st-patrol.sh

# With help (if available)
./at-st-patrol.sh --help
```

---

## Requirements

- Bash 4.0+
- Termux or Linux/macOS

## Examples

```bash
# Example 1
./at-st-patrol.sh

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
| Permission denied | `chmod +x at-st-patrol.sh` |
| Command not found | Install required dependencies |
| Script fails | Check `bash -x at-st-patrol.sh` for debug |

---

## Related Scripts

| Script | Purpose |
|--------|---------|
| [bootstrap-repo](../bootstrap-repo/) | One-shot repo creation |
| [force-push](../force-push/) | Git deployment |
| [r2d2-repair-bay](../r2d2-repair-bay/) | Dependency repair |

---

## Source

View the [`at-st-patrol.sh`](at-st-patrol.sh) source code in the parent directory.

---

**Created:** 2026-02-23  
**Category:** security  
**Priority:** HIGH  
**Status:** ✅ Tested
