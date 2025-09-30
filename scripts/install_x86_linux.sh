#!/bin/bash

# Telegram Video Downloader Bot - Installation Script for x86 Linux
# This script automatically installs and sets up the bot

set -e

echo "🤖 Telegram Video Downloader Bot - Installation Script"
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Python 3 is available and compatible
echo -e "${YELLOW}Checking Python version...${NC}"
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Python 3 is not installed. Please install it first.${NC}"
    echo "You can install it using:"
    echo "  - Ubuntu/Debian: sudo apt update && sudo apt install python3 python3-venv python3-pip"
    echo "  - Or use pyenv: pyenv install 3.12.0 && pyenv global 3.12.0"
    exit 1
fi

# Check Python version compatibility (3.8 <= version <= 3.12)
PYTHON_VERSION=$(python3 --version 2>&1)
if ! python3 -c "import sys; exit(0 if (3, 8) <= sys.version_info <= (3, 12) else 1)" 2>/dev/null; then
    echo -e "${RED}Python version $PYTHON_VERSION is not supported.${NC}"
    echo -e "${RED}Supported versions: Python 3.8 - 3.12 (PyO3 limitation)${NC}"
    echo "You can install Python 3.12 using:"
    echo "  - Ubuntu/Debian: sudo apt update && sudo apt install python3.12 python3.12-venv"
    echo "  - Or use pyenv: pyenv install 3.12.0 && pyenv global 3.12.0"
    exit 1
fi

echo -e "${GREEN}✓ Compatible $PYTHON_VERSION found${NC}"

# Get project root directory (parent of scripts)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT"

# Create virtual environment
echo -e "${YELLOW}Creating virtual environment...${NC}"
python3 -m venv venv
echo -e "${GREEN}✓ Virtual environment created${NC}"

# Activate virtual environment and install dependencies
echo -e "${YELLOW}Installing dependencies...${NC}"
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
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

# Make launch script executable
if [ -f "scripts/launch_x86_linux.sh" ]; then
    chmod +x scripts/launch_x86_linux.sh
    echo -e "${GREEN}✓ Launch script made executable${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Installation completed successfully!${NC}"
echo ""
echo "Next steps:"
echo "1. Edit secrets/.env file and add your bot token"
echo "2. (Optional) Add Instagram cookies to secrets/www.instagram.com_cookies.txt"
echo "3. Run the bot using: ./scripts/launch_x86_linux.sh"
echo "   or manually: source venv/bin/activate && python main.py"
