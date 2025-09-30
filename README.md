# 🎥 Telegram Video Downloader Bot

A powerful Telegram bot that downloads videos from various platforms with advanced features and user-friendly interface.

## ✨ Features

- 📥 Download videos from Instagram, YouTube, TikTok, and 100+ other platforms
- 🎛️ Interactive description management (keep/remove options)
- 🧹 Auto-cleanup of original messages for cleaner chat
- 🔧 Modular and maintainable code structure
- 📱 Support for both x86 Linux and ARM Termux (Android)
- 🍪 Instagram cookie authentication support
- 🚀 Automated installation and launch scripts

## 🚀 Quick Installation

### For x86 Linux:
```bash
chmod +x scripts/install_x86_linux.sh
./scripts/install_x86_linux.sh
```

### For ARM Termux (Android):
```bash
chmod +x scripts/install_arm_termux.sh
./scripts/install_arm_termux.sh
```

## 🛠️ Manual Installation

### Prerequisites
- Python 3.12 (recommended) or Python 3.8+
- pip (Python package manager)

### Installation Steps
1. **Switch to Python 3.12** (using pyenv or system package manager):
   ```bash
   pyenv install 3.12.0 && pyenv global 3.12.0
   # or for Ubuntu/Debian:
   # sudo apt update && sudo apt install python3.12 python3.12-venv
   ```

2. **Create virtual environment**:
   ```bash
   python3.12 -m venv venv
   ```

3. **Activate virtual environment**:
   ```bash
   source venv/bin/activate
   ```

4. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

5. **Create .env file**:
   ```bash
   echo "BOT_TOKEN=your_bot_token_here" > .env
   ```

6. **Run the bot**:
   ```bash
   python main.py
   ```

## 🎯 Usage

1. **Start the bot**: Send `/start` command
2. **Send video URL**: Paste any video link from supported platforms
3. **Manage description**: Use the interactive buttons to keep or remove video description
4. **Enjoy**: The bot automatically cleans up your chat and provides a smooth experience

## ⚙️ Configuration

### Environment Variables (.env)
```env
BOT_TOKEN=your_telegram_bot_token_here
```

### Instagram Cookies (Optional)
For better Instagram support, add your cookies to `secrets/www.instagram.com_cookies.txt`

## 🚀 Launch Scripts

### Linux:
```bash
./scripts/launch_x86_linux.sh
```

### Termux (Android):
```bash
~/.shortcuts/launch_arm_termux.sh
# or
./scripts/launch_arm_termux.sh
```

## 🔧 Development

The bot is built with a modular structure:
- **main.py**: Entry point and bot initialization
- **src/config.py**: Configuration management
- **src/handlers.py**: Message and callback handlers
- **src/utils.py**: Utility functions and helpers

## 📋 Requirements

- Python 3.8+ (3.12 recommended)
- aiogram 3.7.0
- yt-dlp 2024.4.9+
- python-dotenv 1.0.0+
