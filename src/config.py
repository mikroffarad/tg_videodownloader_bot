"""
Configuration module for the Telegram Video Downloader Bot.
"""

import os
from dataclasses import dataclass
from typing import Optional


@dataclass
class BotConfig:
    """Bot configuration class."""

    # Bot settings
    bot_token: str

    # Download settings
    output_template: str = "downloads/video.%(ext)s"
    video_format: str = "mp4/best"
    cookies_file: Optional[str] = None

    # Telegram settings
    caption_max_length: int = 1024

    # File settings
    downloads_dir: str = "downloads"

    @classmethod
    def from_env(cls) -> "BotConfig":
        """Create configuration from environment variables."""
        # Try to load .env from secrets directory first, then root
        from dotenv import load_dotenv

        secrets_env = os.path.join("secrets", ".env")
        if os.path.exists(secrets_env):
            load_dotenv(secrets_env)
        else:
            load_dotenv()  # Load from root directory as fallback

        bot_token = os.getenv("BOT_TOKEN")
        if not bot_token:
            raise ValueError("BOT_TOKEN not found in environment variables")

        # Look for cookies in secrets directory first, then root
        cookies_paths = [
            os.path.join("secrets", "www.instagram.com_cookies.txt"),
            "www.instagram.com_cookies.txt"
        ]

        cookies_file = None
        for path in cookies_paths:
            if os.path.exists(path):
                cookies_file = os.path.abspath(path)
                break

        return cls(
            bot_token=bot_token,
            cookies_file=cookies_file,
            output_template=os.path.join("downloads", "video.%(ext)s"),
        )

    def get_ydl_opts(self) -> dict:
        """Get yt-dlp options."""
        opts = {
            "outtmpl": self.output_template,
            "format": self.video_format,
            "quiet": True,
            # Add options to bypass YouTube restrictions
            "extractor_args": {
                "youtube": {
                    "skip": ["dash", "hls"],  # Skip adaptive formats that might cause issues
                    "player_client": ["android", "web"],  # Use multiple clients
                    "player_skip": ["configs"],
                }
            },
            # Use custom user agent
            "http_headers": {
                "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
            },
            # Retry options
            "retries": 3,
            "fragment_retries": 3,
            # Don't check SSL certificates (sometimes helps with geo-blocked content)
            "nocheckcertificate": True,
        }

        if self.cookies_file and os.path.exists(self.cookies_file):
            opts["cookiefile"] = self.cookies_file

        return opts
