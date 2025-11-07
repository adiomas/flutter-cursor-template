#!/bin/bash
# Check Latest Stable Versions for Flutter Dependencies
# Usage: ./.cursor/tools/check_latest_versions.sh [package_name]

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Flutter Dependency Version Checker${NC}\n"

# Function to get latest version from pub.dev
get_latest_version() {
    local package=$1
    local url="https://pub.dev/api/packages/${package}"
    
    # Fetch package data
    local response=$(curl -s "$url")
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error fetching data for ${package}${NC}"
        return 1
    fi
    
    # Extract latest stable version
    local latest=$(echo "$response" | grep -o '"latest":{"version":"[^"]*"' | cut -d'"' -f6)
    
    if [ -z "$latest" ]; then
        echo -e "${RED}Could not find latest version for ${package}${NC}"
        return 1
    fi
    
    echo "$latest"
}

# Function to get package score
get_package_score() {
    local package=$1
    local url="https://pub.dev/api/packages/${package}/score"
    
    local response=$(curl -s "$url")
    
    if [ $? -ne 0 ]; then
        return 1
    fi
    
    # Extract scores
    local granted=$(echo "$response" | grep -o '"grantedPoints":[0-9]*' | cut -d':' -f2)
    local max=$(echo "$response" | grep -o '"maxPoints":[0-9]*' | cut -d':' -f2)
    
    if [ -n "$granted" ] && [ -n "$max" ]; then
        echo "${granted}/${max}"
    else
        echo "N/A"
    fi
}

# Function to check single package
check_package() {
    local package=$1
    
    echo -e "${YELLOW}Checking ${package}...${NC}"
    
    local latest=$(get_latest_version "$package")
    
    if [ $? -eq 0 ]; then
        local score=$(get_package_score "$package")
        echo -e "${GREEN}✓${NC} ${package}: ^${latest} (Score: ${score})"
        
        # Return version for use
        echo "  ${package}: ^${latest}"
    else
        echo -e "${RED}✗${NC} Failed to check ${package}"
    fi
    
    echo ""
}

# Default packages to check if no argument provided
default_packages=(
    "hooks_riverpod"
    "flutter_hooks"
    "go_router"
    "either_dart"
    "equatable"
    "intl"
    "supabase_flutter"
    "dio"
    "json_annotation"
    "flutter_svg"
    "google_fonts"
    "flutter_animate"
    "flutter_screenutil"
    "shared_preferences"
    "loggy"
    "flutter_loggy"
    "permission_handler"
    "file_picker"
    "image_picker"
    "url_launcher"
    "share_plus"
    "path"
    "build_runner"
    "json_serializable"
    "flutter_lints"
    "custom_lint"
    "riverpod_lint"
    "mocktail"
)

# If argument provided, check only that package
if [ $# -eq 1 ]; then
    check_package "$1"
else
    # Check all default packages
    echo -e "${BLUE}Checking all recommended packages...${NC}\n"
    
    echo "# Suggested versions for pubspec.yaml:"
    echo ""
    echo "dependencies:"
    
    for package in "${default_packages[@]}"; do
        if [[ "$package" != "build_runner" && "$package" != "json_serializable" && "$package" != "flutter_lints" && "$package" != "custom_lint" && "$package" != "riverpod_lint" && "$package" != "mocktail" ]]; then
            check_package "$package" | tail -n 1
        fi
    done
    
    echo ""
    echo "dev_dependencies:"
    
    for package in "build_runner" "json_serializable" "flutter_lints" "custom_lint" "riverpod_lint" "mocktail"; do
        check_package "$package" | tail -n 1
    done
fi

echo -e "\n${GREEN}✅ Version check complete!${NC}"
echo -e "${YELLOW}💡 Tip: Copy the versions above and paste into your pubspec.yaml${NC}"

