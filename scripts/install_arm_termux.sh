#!/bin/bash

# Telegram Video Downloader Bot - Installation Script for ARM Termux
# This script automatically installs and sets up the bot on Android Termux

set -e

echo "🤖 Telegram Video Downloader Bot - Installation Script for Termux"
echo "============================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Update packages
echo -e "${YELLOW}Updating Termux packages...${NC}"
pkg update -y
pkg upgrade -y

# Install Python and essential packages
echo -e "${YELLOW}Installing Python and essential packages...${NC}"
pkg install -y python python-pip git

# Install temporary build dependencies for compilation
echo -e "${YELLOW}Installing temporary build dependencies...${NC}"
BUILD_PACKAGES="build-essential libffi openssl clang rust"
pkg install -y $BUILD_PACKAGES
echo -e "${GREEN}✓ Build dependencies installed${NC}"

# Check Python version
echo -e "${YELLOW}Checking Python version...${NC}"
python --version

# Get project root directory (parent of scripts)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT"

# Create virtual environment
echo -e "${YELLOW}Creating virtual environment...${NC}"
python -m venv venv
echo -e "${GREEN}✓ Virtual environment created${NC}"

# Activate virtual environment and install dependencies
echo -e "${YELLOW}Installing Python dependencies...${NC}"
source venv/bin/activate
pip install --upgrade pip

# Install from standard requirements.txt (build dependencies are now available)
echo -e "${YELLOW}Installing packages (this may take a while for ARM compilation)...${NC}"
pip install -r requirements.txt
echo -e "${GREEN}✓ Python dependencies installed${NC}"

# Clean up build dependencies to save space
echo -e "${YELLOW}Cleaning up temporary build dependencies...${NC}"
echo -e "${YELLOW}Removing: $BUILD_PACKAGES${NC}"
pkg uninstall -y $BUILD_PACKAGES || echo -e "${YELLOW}Some packages couldn't be removed (might be needed by other apps)${NC}"
pkg clean
echo -e "${GREEN}✓ Build dependencies cleaned up${NC}"

# Create secrets directory and .env file if they don't exist
mkdir -p secrets
if [ ! -f secrets/.env ]; then
    echo -e "${YELLOW}Creating secrets/.env file...${NC}"
    echo "BOT_TOKEN=" > secrets/.env
    echo -e "${GREEN}✓ secrets/.env file created${NC}"
    echo -e "${YELLOW}Please edit secrets/.env file and add your bot token:${NC}"
    echo "  BOT_TOKEN=your_bot_token_here"
else
    echo -e "${GREEN}✓ secrets/.env file already exists${NC}"
fi

# Create shortcuts directory if it doesn't exist
mkdir -p ~/.shortcuts

# Copy launch script to shortcuts
if [ -f "scripts/launch_arm_termux.sh" ]; then
    cp scripts/launch_arm_termux.sh ~/.shortcuts/
    chmod +x ~/.shortcuts/launch_arm_termux.sh
    echo -e "${GREEN}✓ Launch script copied to ~/.shortcuts/${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Installation completed successfully!${NC}"
echo ""
echo "Next steps:"
echo "1. Edit secrets/.env file and add your bot token: nano secrets/.env"
echo "2. (Optional) Add Instagram cookies to secrets/www.instagram.com_cookies.txt"
echo "3. Run the bot using: ~/.shortcuts/launch_arm_termux.sh"
echo "   or manually: source venv/bin/activate && python main.py"
echo ""
echo "Note: The launch script is available in your Termux shortcuts widget!"
