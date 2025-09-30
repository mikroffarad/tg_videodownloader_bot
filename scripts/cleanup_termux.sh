#!/bin/bash

# Cleanup script for Termux - removes build dependencies and cleans cache

echo "🧹 Termux Cleanup Script"
echo "======================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Build packages that are safe to remove after installation
BUILD_PACKAGES="rust build-essential clang"
OPTIONAL_PACKAGES="libffi openssl"

echo -e "${YELLOW}Removing build dependencies...${NC}"

# Remove build packages
for package in $BUILD_PACKAGES; do
    if pkg list-installed | grep -q "^$package/"; then
        echo -e "${YELLOW}Removing $package...${NC}"
        if pkg uninstall -y "$package" 2>/dev/null; then
            echo -e "${GREEN}✓ $package removed${NC}"
        else
            echo -e "${YELLOW}⚠ $package couldn't be removed (might be needed by other apps)${NC}"
        fi
    else
        echo -e "${YELLOW}• $package not installed${NC}"
    fi
done

# Ask about optional packages
echo -e "${YELLOW}Optional packages (used during build):${NC}"
for package in $OPTIONAL_PACKAGES; do
    if pkg list-installed | grep -q "^$package/"; then
        echo -e "${YELLOW}Found $package - this might be used by other apps.${NC}"
        read -p "Remove $package? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if pkg uninstall -y "$package" 2>/dev/null; then
                echo -e "${GREEN}✓ $package removed${NC}"
            else
                echo -e "${YELLOW}⚠ $package couldn't be removed${NC}"
            fi
        else
            echo -e "${YELLOW}• $package kept${NC}"
        fi
    fi
done

# Clean package cache
echo -e "${YELLOW}Cleaning package cache...${NC}"
pkg clean
echo -e "${GREEN}✓ Package cache cleaned${NC}"

# Show space saved
echo ""
echo -e "${GREEN}🎉 Cleanup completed!${NC}"
echo -e "${YELLOW}Tip: Run 'du -sh ~/.termux' to check storage usage${NC}"
