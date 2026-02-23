#!/usr/bin/env bash
# =====================================================
# repo-rename.sh - GitHub Repository Batch Renamer
# Renames repos to snake_case naming convention
# Usage: ./repo-rename.sh [--dry-run]
# =====================================================

set -e

DRY_RUN="${1:-}"
ORG="Turbo-the-tech-dev"

echo "[*] GITHUB REPOSITORY RENAMER"
echo "    Organization: $ORG"
echo ""

# Repository rename mappings: OLD -> NEW
declare -A RENAMES=(
    ["ELECTRICIAN-INDEX"]="electrician_index"
    ["ELECTRICIAN-backup"]="electrician_backup"
    ["Electrician-interview"]="electrician_interview"
    ["Electrician"]="electrician_core"
)

# Check for gh CLI
if ! command -v gh &> /dev/null; then
    echo "[!] ERROR: GitHub CLI (gh) not installed"
    echo "    Install: sudo apt install gh  OR  brew install gh"
    exit 1
fi

# Verify authentication
echo "[+] Checking GitHub authentication..."
if ! gh auth status &> /dev/null; then
    echo "[!] ERROR: Not authenticated with GitHub"
    echo "    Run: gh auth login"
    exit 1
fi
echo "    Authenticated OK"
echo ""

# Process each repository
for old_name in "${!RENAMES[@]}"; do
    new_name="${RENAMES[$old_name]}"
    
    echo "----------------------------------------"
    echo "Repository: $old_name -> $new_name"
    
    # Check if source repo exists
    if ! gh repo view "$ORG/$old_name" &> /dev/null; then
        echo "    [!] SKIP: Source repo '$ORG/$old_name' not found"
        continue
    fi
    
    # Check if target repo already exists
    if gh repo view "$ORG/$new_name" &> /dev/null; then
        echo "    [!] SKIP: Target repo '$ORG/$new_name' already exists"
        continue
    fi
    
    # Dry run mode
    if [ "$DRY_RUN" = "--dry-run" ]; then
        echo "    [DRY-RUN] Would rename: $old_name -> $new_name"
        continue
    fi
    
    # Confirm before rename
    read -p "    Proceed with rename? (y/N): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "    Skipped."
        continue
    fi
    
    # Execute rename
    echo "    Renaming..."
    if gh repo rename "$old_name" "$new_name" -R "$ORG/$old_name" --confirm; then
        echo "    [✓] SUCCESS: $old_name -> $new_name"
        
        # Update local remote URLs if repos are cloned locally
        if [ -d "./$old_name" ]; then
            echo "    Updating local remote URL..."
            cd "$old_name"
            git remote set-url origin "https://github.com/$ORG/$new_name.git"
            cd ..
        fi
    else
        echo "    [!] FAILED: Rename encountered an error"
    fi
    
    sleep 1
done

echo ""
echo "----------------------------------------"
echo "[###] RENAME OPERATION COMPLETE"
echo ""
echo "Next steps:"
echo "  1. Update any CI/CD pipelines referencing old repo names"
echo "  2. Update local git remotes: git remote set-url origin <new-url>"
echo "  3. Update documentation/links pointing to old repo URLs"
echo ""
echo "To verify:"
echo "  gh repo list $ORG --limit 10"
