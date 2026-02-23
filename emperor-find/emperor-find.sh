#!/bin/bash

# Emperor Find - A Lord Vader Teaching Script
# Purpose: Master the tools of the Empire: grep, awk, sed, and ripgrep

# ── Colors & Constants ───────────────────────────────
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# ── Functions ────────────────────────────────────────

pause() {
    echo -e "${RED}Press [Enter] to continue your training, apprentice...${NC}"
    read -r
}

vader_echo() {
    echo -e "${BOLD}${RED}VADER:${NC} $1"
    sleep 1.5
}

ascii_art() {
    clear
    echo -e "${RED}"
    echo "                _  _ "
    echo "               | \/ |"
    echo "    _  _       |    |       _  _"
    echo "   | \/ |      |    |      | \/ |"
    echo "   |    |______|    |______|    |"
    echo "   |    |      |    |      |    |"
    echo "   |    |      |    |      |    |"
    echo "   |____|      |____|      |____|"
    echo "    \  /        \  /        \  /"
    echo "     \/          \/          \/"
    echo "       EMPEROR FIND v1.0"
    echo -e "${NC}"
}

lesson_grep() {
    ascii_art
    vader_echo "I find your lack of search skills disturbing."
    echo "------------------------------------------------"
    echo "Lesson 1: GREP (Global Regular Expression Print)"
    echo "Grep is used to find strings within files."
    echo ""
    echo "Command: grep 'pattern' filename"
    echo "Example: grep 'Death Star' plans.txt"
    echo "Power Tip: Use -i for case-insensitive search."
    echo "------------------------------------------------"
    vader_echo "Search your feelings... and the files. You know it to be true."
    pause
}

lesson_ripgrep() {
    ascii_art
    vader_echo "Ripgrep is the ultimate power in the universe. It is faster than Grep."
    echo "------------------------------------------------"
    echo "Lesson 2: RIPGREP (rg)"
    echo "rg is a modern replacement for grep. It is blazing fast."
    echo ""
    echo "Command: rg 'pattern'"
    echo "Power Tip: It automatically ignores files in your .gitignore."
    echo "Try: rg -w 'Vader' (finds whole word only)"
    echo "------------------------------------------------"
    vader_echo "Don't be too proud of this technological terror you've constructed."
    pause
}

lesson_sed() {
    ascii_art
    vader_echo "Sed allows us to alter reality... or at least the text."
    echo "------------------------------------------------"
    echo "Lesson 3: SED (Stream Editor)"
    echo "Sed is primarily used for finding and replacing text."
    echo ""
    echo "Command: sed 's/old/new/g' filename"
    echo "Example: sed 's/Rebel/Empire/g' report.txt"
    echo "Power Tip: Use -i to save changes to the file directly."
    echo "------------------------------------------------"
    vader_echo "I am altering the file. Pray I do not alter it any further."
    pause
}

lesson_awk() {
    ascii_art
    vader_echo "Awk processes the data fields of the galaxy."
    echo "------------------------------------------------"
    echo "Lesson 4: AWK"
    echo "Awk is a full programming language for processing columns."
    echo ""
    echo "Command: awk '{print \$1}' filename"
    echo "Example: ls -l | awk '{print \$9, \$5}'"
    echo "(Prints the filename and size from ls -l)"
    echo "------------------------------------------------"
    vader_echo "You have controlled your fields. Now, release your data."
    pause
}

# ── Main Loop ────────────────────────────────────────

while true; do
    ascii_art
    echo "1) Learn GREP"
    echo "2) Learn RIPGREP (rg)"
    echo "3) Learn SED"
    echo "4) Learn AWK"
    echo "q) Quit and join the Dark Side"
    echo ""
    read -p "Your choice, apprentice: " choice

    case $choice in
        1) lesson_grep ;;
        2) lesson_ripgrep ;;
        3) lesson_sed ;;
        4) lesson_awk ;;
        q|Q) 
            vader_echo "The Force will be with you. Always."
            exit 0 
            ;;
        *) 
            vader_echo "That choice is not as strong as you think."
            sleep 1
            ;;
    esac
done
