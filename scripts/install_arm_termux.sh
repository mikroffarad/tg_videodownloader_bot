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

# Install Python and dependencies
echo -e "${YELLOW}Installing Python and required packages...${NC}"
pkg install -y python python-pip git build-essential libffi libffi-dev openssl-dev

# Install rust if needed for some packages
echo -e "${YELLOW}Installing additional build tools...${NC}"
pkg install -y rust || echo -e "${YELLOW}Rust installation failed, continuing without it...${NC}"

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
echo -e "${YELLOW}Installing dependencies...${NC}"
source venv/bin/activate
pip install --upgrade pip

# Use Termux-specific requirements if available, otherwise fallback to main requirements
if [ -f "requirements-termux.txt" ]; then
    echo -e "${YELLOW}Using Termux-optimized requirements...${NC}"
    if ! pip install -r requirements-termux.txt; then
        echo -e "${RED}Failed to install Termux requirements. Trying manual installation...${NC}"
        pip install aiogram==3.4.1 || pip install aiogram
        pip install yt-dlp
        pip install python-dotenv
        pip install requests
        pip install "pydantic<2.0" || pip install pydantic==1.10.12
        pip install aiohttp
        pip install aiofiles
    fi
else
    echo -e "${YELLOW}Using standard requirements...${NC}"
    if ! pip install -r requirements.txt; then
        echo -e "${RED}Failed to install standard requirements. Trying Termux compatibility mode...${NC}"
        pip install aiogram==3.4.1 || pip install aiogram
        pip install yt-dlp
        pip install python-dotenv
        pip install requests
        pip install "pydantic<2.0" || pip install pydantic==1.10.12
    fi
fi

echo -e "${GREEN}✓ Dependencies installed${NC}"

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
