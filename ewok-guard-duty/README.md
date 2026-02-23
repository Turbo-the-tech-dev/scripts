# Ewok-guard-duty

> Login audit & perimeter defense

---

## Quick Start

```bash
./ewok-guard-duty.sh
```

---

## Script Information

| Property | Value |
|----------|-------|
| **File** | `ewok-guard-duty.sh` |
| **Category** | security |
| **Priority** | MEDIUM |
| **Lines** | 192 |
| **Size** | 8.0K |
| **Shebang** | `#!/usr/bin/env bash` |

---

## Sandbox Test Results

| Test | Status | Details |
|------|--------|---------|
| Syntax Check | ✅ PASS | `bash -n ewok-guard-duty.sh` |
| File Exists | ✅ PASS | File present in repo |
| Executable | ✅ PASS | chmod +x applied |
| Shebang Valid | ✅ PASS | #!/usr/bin/env bash |

---

## Features

<!-- Analyzed from script source -->

## Key Functions

```
init_log,log_event,record_login,check_failed_logins,monitor_mode,report_mode,setup_mode
```

## Commands Used

echo,grep,

---

## Usage

```bash
# Basic usage
cd ~/scripts
./ewok-guard-duty.sh

# With help (if available)
./ewok-guard-duty.sh --help
```

---

## Requirements

- Bash 4.0+
- Termux or Linux/macOS

## Examples

```bash
# Example 1
./ewok-guard-duty.sh

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
| Permission denied | `chmod +x ewok-guard-duty.sh` |
| Command not found | Install required dependencies |
| Script fails | Check `bash -x ewok-guard-duty.sh` for debug |

---

## Related Scripts

| Script | Purpose |
|--------|---------|
| [bootstrap-repo](../bootstrap-repo/) | One-shot repo creation |
| [force-push](../force-push/) | Git deployment |
| [r2d2-repair-bay](../r2d2-repair-bay/) | Dependency repair |

---

## Source

View the [`ewok-guard-duty.sh`](ewok-guard-duty.sh) source code in the parent directory.

---

**Created:** 2026-02-23  
**Category:** security  
**Priority:** MEDIUM  
**Status:** ✅ Tested
