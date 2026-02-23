#!/usr/bin/env bash
# super-cat-archive.sh - The Sovereign Grand Archive Protocol
# Measurable Outcome: Total system mapping and concatenation with zero data loss.

STAMP=$(date +%Y%m%d_%H%M%S)
ROOT_DIR=$(pwd)
FINAL_CAT="The_Great_Cat_${STAMP}.md"
TREE_FILE="tree_${STAMP}.md"
LS_FILE="ls_${STAMP}.md"

echo "[*] INITIALIZING GRAND ARCHIVE SNAPSHOT: $STAMP"

# 1. Map the Surface (ls.md)
echo "# Global Directory Map - $STAMP" > "$LS_FILE"
ls -R >> "$LS_FILE"

# 2. Map the Skeleton (tree.md)
if command -v tree &> /dev/null; then
    echo "# Global System Tree - $STAMP" > "$TREE_FILE"
    tree -a >> "$TREE_FILE"
else
    echo "[!] Tree not found. R2-D2 is simulating tree with find..."
    find . -maxdepth 3 -not -path '*/.*' > "$TREE_FILE"
fi

# 3. Recursive Dive and Harvest
echo "# The Great Concatenation - $STAMP" > "$FINAL_CAT"

# We use 'find' to navigate every directory to avoid shell depth limits
find . -type d -not -path '*/.*' | while read -r dir; do
    echo "[+] Processing: $dir"
    cd "$dir" || continue
    
    # Create local ls.txt for this specific sector
    ls > ls.txt
    
    # Append to the Master Cat with high-acuity headers
    DIR_NAME=$(basename "$dir")
    echo "## SECTOR: $DIR_NAME" >> "$ROOT_DIR/$FINAL_CAT"
    echo "### Path: $dir" >> "$ROOT_DIR/$FINAL_CAT"
    
    for file in *; do
        # Only cat real files, skip the logs we just created
        if [ -f "$file" ] && [[ "$file" != "ls.txt" ]] && [[ "$file" != *.md ]]; then
            EXT="${file##*.}"
            echo "#### FILE: $file" >> "$ROOT_DIR/$FINAL_CAT"
            echo '```' >> "$ROOT_DIR/$FINAL_CAT"
            cat "$file" >> "$ROOT_DIR/$FINAL_CAT" 2>&1
            echo -e '\n```\n' >> "$ROOT_DIR/$FINAL_CAT"
            
            # BONUS: Type-specific Categorization
            TYPE_FILE="$ROOT_DIR/Type_Cat_${EXT}_${STAMP}.md"
            echo "## FROM: $dir/$file" >> "$TYPE_FILE"
            echo '```' >> "$TYPE_FILE"
            cat "$file" >> "$TYPE_FILE" 2>&1
            echo -e '\n```\n' >> "$TYPE_FILE"
        fi
    done
    
    cd "$ROOT_DIR" || exit
done

echo "[###] ARCHIVE COMPLETE."
echo "      Files: $LS_FILE, $TREE_FILE, $FINAL_CAT"
