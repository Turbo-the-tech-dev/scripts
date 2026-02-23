# Create World Words

> Generate world vocabulary structure for 47 countries, 60+ languages, 10,000 words each

---

## Quick Start

```bash
./create-world-words.sh
```

---

## Script Information

| Property | Value |
|----------|-------|
| **File** | `create-world-words.sh` |
| **Category** | Deployment |
| **Priority** | HIGH |
| **Lines** | 120+ |
| **Size** | 4.0K |

---

## Sandbox Test Results

| Test | Status | Details |
|------|--------|---------|
| Syntax Check | ✅ PASS | `bash -n create-world-words.sh` |
| File Exists | ✅ PASS | File present |
| Executable | ✅ PASS | chmod +x applied |
| Execution | ✅ PASS | Creates 246 directories |

---

## Features

- **47 Countries** - Major nations across all continents
- **60+ Languages** - Primary language per country
- **10,000 Word Structure** - Organized in 1000-word batches
- **Auto READMEs** - Generated for each country and language
- **Word Template** - Standardized format for word entries
- **Git Ready** - Easy to commit and push

---

## Directory Structure Created

```
words/
├── US/
│   ├── README.md
│   └── words/
│       └── english/
│           └── 10000-words/
│               ├── README.md
│               └── words-0001-0100.txt
├── MX/
│   └── words/
│       └── spanish/
│           └── 10000-words/
├── JP/
│   └── words/
│       └── japanese/
│           └── 10000-words/
... (47 countries total)
```

---

## Countries Included

| Region | Countries |
|--------|-----------|
| North America | US, CA, MX |
| Europe | GB, DE, FR, ES, IT, PT, NL, SE, NO, DK, FI, PL, RU, UA, GR, TR |
| Asia | CN, JP, KR, IN, TH, VN, ID, MY, PH, SG, HK, TW |
| Middle East | SA, AE, IL, IR |
| Africa | ZA, EG, NG, KE, ET |
| South America | BR, AR, CL, CO, PE |
| Oceania | AU, NZ |

---

## Word File Format

```
word|part_of_speech|definition|example_sentence

the|article|used to specify a noun|The book is on the table.
be|verb|exist or occur|I want to be happy.
```

---

## Usage

```bash
# Run the script
./create-world-words.sh

# Output shows:
# - Base directory
# - Countries processed
# - Total directories created
```

### Sample Output

```
Creating world words directory structure...
Base: /path/to/pkg/words

✅ Directory structure created!

Summary:
  Countries: 47
  Total directories: 246
```

---

## Requirements

| Tool | Required | Purpose |
|------|----------|---------|
| `bash` | ✅ | Shell interpreter |
| `mkdir` | ✅ | Directory creation |
| `git` | Optional | Version control |

---

## Customization

Edit the `COUNTRIES` associative array to add/remove countries:

```bash
declare -A COUNTRIES=(
    ["XX"]="language1 language2"
    # Add your country here
)
```

---

## Related Scripts

| Script | Purpose |
|--------|---------|
| [bootstrap-repo](../bootstrap-repo/) | Create repo for words |
| [master-cat](../master-cat/) | Document word files |

---

**Created:** 2026-02-23  
**Category:** Deployment  
**Priority:** HIGH  
**Status:** ✅ Production Ready
