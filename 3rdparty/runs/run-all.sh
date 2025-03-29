#!/bin/bash

# Color definitions for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

GITHUB_REPO="https://github.com/cosdt/kunpeng-softwares.git"
PROJECT_ROOT="/tmp/kunpeng-softwares"

# clone repository
clone_repository() {
    echo -e "${YELLOW}▶ Cloning repository from GitHub...${NC}"
    if [ -d "$PROJECT_ROOT" ]; then
        rm -rf $PROJECT_ROOT
    fi

    if git clone "$GITHUB_REPO" "$PROJECT_ROOT" 2>/dev/null; then
        echo -e "${GREEN}✓ Repository cloned successfully${NC}"
        return 0
    fi
}

# execute a script with its software-list
run_script() {
    local script_path="$1"
    local script_dir="$(dirname "$script_path")"
    local software_list="${script_dir}/software-list"

    echo -e "${YELLOW}▶ Running: $script_path${NC}"

    if [[ ! -f "$script_path" ]]; then
        echo -e "${RED}✗ Error: $script_path not found${NC}"
        return 1
    fi

    chmod +x "$script_path" 2>/dev/null

    # Read software-list if exists
#    local args=""
#    if [[ -f "$software_list" ]]; then
#        args=$(grep -v '^#' "$software_list" | tr '\n' ' ')
#        echo -e "Using software-list: ${args}"
#    else
#        echo -e "${YELLOW}⚠ Warning: software-list not found in $script_dir${NC}"
#    fi

#    if bash "$script_path" $args; then
    if bash "$script_path"; then
        echo -e "${GREEN}✓ Success: $script_path${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed: $script_path${NC}"
        return 1
    fi
}

echo -e "\n===== STARTING EXECUTION ====="
echo "Project Root: $PROJECT_ROOT"

scripts=(
    "${PROJECT_ROOT}/3rdparty/conda/run.sh"
    "${PROJECT_ROOT}/3rdparty/maven/run.sh"
    "${PROJECT_ROOT}/3rdparty/npm/run.sh"
    "${PROJECT_ROOT}/3rdparty/pypi/run.sh"
)

# Execute all scripts and track results
total=${#scripts[@]}
success=0
for script in "${scripts[@]}"; do
    if run_script "$script"; then
        ((success++))
    fi
done

if [ -d "$PROJECT_ROOT" ]; then
    rm -rf $PROJECT_ROOT
fi

echo -e "\n===== SUMMARY ====="
(( success == total )) || exit 1
