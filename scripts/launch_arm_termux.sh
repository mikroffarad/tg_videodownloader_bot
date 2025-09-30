#!/bin/bash

# Telegram Video Downloader Bot - Launch Script for ARM Termux

set -e

echo "🚀 Starting Telegram Video Downloader Bot on Termux..."

# Get the directory where the bot is located
# Assuming the bot is in the home directory or adjust the path as needed
BOT_DIR="$HOME/tg_videodownloader_bot"

# If running from shortcuts, we need to navigate to bot directory
if [ -d "$BOT_DIR" ]; then
    cd "$BOT_DIR"
else
    # Try current directory if BOT_DIR doesn't exist
    if [ ! -f "main.py" ]; then
        echo "❌ Bot directory not found. Please make sure the bot is installed."
        echo "Expected location: $BOT_DIR"
        exit 1
    fi
fi

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "❌ Virtual environment not found. Please run install_arm_termux.sh first."
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
