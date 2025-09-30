# Termux Installation Guide

## Known Issues and Solutions

### Problem: pydantic-core compilation error with Rust
```
Rust not found, installing into a temporary directory
Unsupported platform: 312
```

### Solutions:

1. **Use the Termux-optimized script:**
   ```bash
   ./scripts/install_arm_termux.sh
   ```

2. **Manual installation if script fails:**
   ```bash
   # Install required system packages
   pkg update && pkg upgrade
   pkg install python python-pip git build-essential libffi libffi-dev openssl-dev rust

   # Create virtual environment
   python -m venv venv
   source venv/bin/activate

   # Install packages one by one
   pip install --upgrade pip
   pip install aiogram==3.4.1
   pip install yt-dlp
   pip install python-dotenv
   pip install requests
   pip install "pydantic<2.0"  # Use older version to avoid Rust compilation
   ```

3. **Alternative: Use pre-compiled wheels**
   ```bash
   pip install --only-binary=all aiogram yt-dlp python-dotenv requests pydantic
   ```

### If you still get compilation errors:
- Make sure you have enough storage space (at least 1GB free)
- Try installing packages without cache: `pip install --no-cache-dir package_name`
- Use older versions that don't require Rust compilation

### Compatibility Notes:
- The bot uses `requirements-termux.txt` with Termux-compatible versions
- Older pydantic (1.x) is used instead of 2.x to avoid Rust compilation
- aiogram 3.4.1 is used instead of 3.7.0 for better ARM compatibility
