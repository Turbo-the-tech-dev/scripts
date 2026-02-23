#!/usr/bin/env bash
# master-cat.sh - The Imperial Archive Protocol
# Measurable Outcome: Flatten directories into a single Markdown study guide.
# Usage: ./master-cat [output_file.md] [directory]

set -e

OUTPUT_FILE="${1:-output.md}"
TARGET_DIR="${2:-.}"

# Check if target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist"
    exit 1
fi

echo "[*] INITIALIZING MASTER CAT PROTOCOL"
echo "    Output: $OUTPUT_FILE"
echo "    Target: $TARGET_DIR"

# Initialize output file with header
cat > "$OUTPUT_FILE" << EOF
# Master Catalog - $(date +%Y-%m-%d_%H:%M:%S)
## Target Directory: $TARGET_DIR

---

EOF

# Counters for stats
file_count=0
dir_count=0

# Iterate through each subdirectory
for dir in "$TARGET_DIR"/*/; do
    [ -d "$dir" ] || continue

    dir_name=$(basename "$dir")
    echo "## $dir_name" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"

    dir_has_files=false

    # Iterate through each file in the directory
    for file in "$dir"*; do
        [ -f "$file" ] || continue

        file_name=$(basename "$file")
        EXT="${file##*.}"

        echo "### $dir_name/$file_name" >> "$OUTPUT_FILE"
        echo "#### Type: $EXT" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"

        # High-Acuity Syntax Wrapping
        echo '```' >> "$OUTPUT_FILE"
        cat "$file" >> "$OUTPUT_FILE" 2>&1
        echo '```' >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"

        dir_has_files=true
        ((file_count++))
    done

    if [ "$dir_has_files" = false ]; then
        echo "*No files in this directory*" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
    fi

    ((dir_count++))
done

echo ""
echo "[###] MASTER CAT COMPLETE"
echo "  - Processed $dir_count directories"
echo "  - Concatenated $file_count files"
echo "  - Output: $OUTPUT_FILE"
