#!/bin/bash

# Telegram Video Downloader Bot - Launch Script for x86 Linux

set -e

echo "🚀 Starting Telegram Video Downloader Bot..."

# Get current directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "❌ Virtual environment not found. Please run install_x86_linux.sh first."
    exit 1
fi

# Check if .env file exists (check secrets directory first, then root)
ENV_FILE=""
if [ -f "secrets/.env" ]; then
    ENV_FILE="secrets/.env"
elif [ -f ".env" ]; then
    ENV_FILE=".env"
else
    echo "❌ .env file not found. Please create secrets/.env and add your BOT_TOKEN."
    exit 1
fi

# Check if BOT_TOKEN is set
if ! grep -q "BOT_TOKEN=." "$ENV_FILE"; then
    echo "❌ BOT_TOKEN not set in $ENV_FILE file. Please add your bot token."
    exit 1
fi

# Activate virtual environment
source venv/bin/activate

# Start the bot
echo "✅ Starting bot..."
python main.py
