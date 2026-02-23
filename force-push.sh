#!/usr/bin/env bash
# Name: force-push.sh
# Purpose: Automate the 'Kylo' deployment flow.
# Measurable Outcome: Executable status verified; Git push confirmed.

# Colors for High-Acuity Feedback
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}[*] INITIALIZING IMPERIAL FORCE-PUSH...${NC}"

# 1. Dependency Check (Black Hat logic)
dependencies=(git figlet)
for cmd in "${dependencies[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        echo -e "${RED}[!] WARNING: $cmd is not installed. Proceeding with caution...${NC}"
    fi
done

# 2. Set Permissions
echo -e "${GREEN}[+] Setting executable permissions for all scripts...${NC}"
chmod +x ~/Kylo/scripts/*.sh 2>/dev/null || chmod +x *.sh

# 3. Git Automation
echo -e "${GREEN}[+] Staging artifacts for the Galaxy...${NC}"
git add .

# Prompt for a military-grade commit message
read -p "Enter Command Directive (Commit Message): " directive
if [ -z "$directive" ]; then
    directive="Standard Sector Update - $(date +%F)"
fi

git commit -m "$directive"

# 4. The Jump to Hyperspace (Push)
echo -e "${CYAN}[*] Pushing to remote repository...${NC}"
if git push origin main; then
    echo -e "${GREEN}[###] DEPLOYMENT SUCCESSFUL. THE GALAXY IS OURS.${NC}"
    if command -v figlet &> /dev/null; then figlet "SUCCESS"; fi
else
    echo -e "${RED}[!] FORCE-PUSH FAILED. Check network link or permissions.${NC}"
    exit 1
fi
