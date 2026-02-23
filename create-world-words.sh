#!/bin/bash
#===============================================================================
# WORLD WORDS DIRECTORY STRUCTURE GENERATOR
# Creates: pkg/words/{COUNTRY_CODE}/words/{LANGUAGE}/10000-words/
#===============================================================================

set -euo pipefail

BASE_DIR="/data/data/com.termux/files/home/pkg/words"

# Country codes with primary languages
declare -A COUNTRIES=(
    # North America
    ["US"]="english"
    ["CA"]="english french"
    ["MX"]="spanish"
    
    # Europe
    ["GB"]="english"
    ["DE"]="german"
    ["FR"]="french"
    ["ES"]="spanish"
    ["IT"]="italian"
    ["PT"]="portuguese"
    ["NL"]="dutch"
    ["SE"]="swedish"
    ["NO"]="norwegian"
    ["DK"]="danish"
    ["FI"]="finnish"
    ["PL"]="polish"
    ["RU"]="russian"
    ["UA"]="ukrainian"
    ["GR"]="greek"
    ["TR"]="turkish"
    
    # Asia
    ["CN"]="chinese mandarin"
    ["JP"]="japanese"
    ["KR"]="korean"
    ["IN"]="hindi english"
    ["TH"]="thai"
    ["VN"]="vietnamese"
    ["ID"]="indonesian"
    ["MY"]="malay english"
    ["PH"]="tagalog english"
    ["SG"]="english chinese malay tamil"
    ["HK"]="cantonese english"
    ["TW"]="mandarin"
    
    # Middle East
    ["SA"]="arabic"
    ["AE"]="arabic english"
    ["IL"]="hebrew arabic"
    ["IR"]="persian"
    
    # Africa
    ["ZA"]="english afrikaans zulu"
    ["EG"]="arabic"
    ["NG"]="english hausa yoruba"
    ["KE"]="english swahili"
    ["ET"]="amharic"
    
    # South America
    ["BR"]="portuguese"
    ["AR"]="spanish"
    ["CL"]="spanish"
    ["CO"]="spanish"
    ["PE"]="spanish"
    
    # Oceania
    ["AU"]="english"
    ["NZ"]="english maori"
)

echo "Creating world words directory structure..."
echo "Base: ${BASE_DIR}"
echo ""

for code in "${!COUNTRIES[@]}"; do
    languages="${COUNTRIES[$code]}"
    
    for lang in $languages; do
        dir_path="${BASE_DIR}/${code}/words/${lang}/10000-words"
        mkdir -p "$dir_path"
        
        # Create README for each language directory
        cat > "${dir_path}/README.md" <<EOF
# 10000 Words - ${lang^} (${code})

Collection of 10,000 essential ${lang} words.

## Structure

\`\`\`
10000-words/
├── README.md
├── words-0001-1000.txt
├── words-1001-2000.txt
├── words-2001-3000.txt
├── ...
└── words-9001-10000.txt
\`\`\`

## Format

\`\`\`
word|part_of_speech|definition|example_sentence
\`\`\`

## Progress

- [ ] 0-1000: Basic vocabulary
- [ ] 1001-2000: Common verbs
- [ ] 2001-3000: Adjectives
- [ ] 3001-4000: Nouns - objects
- [ ] 4001-5000: Nouns - abstract
- [ ] 5001-6000: Adverbs
- [ ] 6001-7000: Prepositions & conjunctions
- [ ] 7001-8000: Technical terms
- [ ] 8001-9000: Idioms & phrases
- [ ] 9001-10000: Advanced vocabulary

## Status: Initialized

EOF
    done
    
    # Create country-level README
    cat > "${BASE_DIR}/${code}/README.md" <<EOF
# ${code} - Country Words Repository

Primary language(s): ${languages}

## Directory Structure

\`\`\`
${code}/
└── words/
$(for lang in $languages; do echo "    └── ${lang}/"; done)
\`\`\`

## Quick Start

\`\`\`bash
cd ${code}/words/${languages%% *}/10000-words/
cat words-0001-1000.txt
\`\`\`

## Languages

| Language | Directory | Status |
|----------|-----------|--------|
$(for lang in $languages; do echo "| ${lang^} | [${lang}/](words/${lang}/) | 📁 Ready |"; done)

---

**ISO Code:** ${code}
**Created:** $(date +%Y-%m-%d)
EOF
done

echo "✅ Directory structure created!"
echo ""
echo "Summary:"
echo "  Countries: ${#COUNTRIES[@]}"
echo "  Total directories: $(find "${BASE_DIR}" -type d | wc -l)"
echo ""
echo "To initialize git and push:"
echo "  cd ${BASE_DIR}"
echo "  git add ."
echo "  git commit -m 'Add world words structure'"
echo "  git push"
