"""
Utilities module for the Telegram Video Downloader Bot.
"""

import os
import requests
from typing import Optional


def resolve_share_url(url: str) -> str:
    """
    If the URL is /share/reel/... Instagram redirects to /reel/...
    Follow the redirect and return the final URL.
    """
    if "/share/reel/" in url:
        try:
            resp = requests.head(url, allow_redirects=True, timeout=10)
            return resp.url
        except Exception:
            return url
    return url


def get_platform_name(url: str) -> str:
    """Determine platform name from URL."""
    if "youtube.com" in url or "youtu.be" in url:
        return "YouTube"
    elif "tiktok.com" in url:
        return "TikTok"
    elif "instagram.com" in url:
        return "Instagram"
    elif "twitter.com" in url or "x.com" in url:
        return "Twitter/X"
    else:
        return "Source"


def ensure_downloads_dir(downloads_dir: str = "downloads") -> None:
    """Ensure downloads directory exists."""
    if not os.path.exists(downloads_dir):
        os.makedirs(downloads_dir)


def cleanup_file(file_path: str) -> None:
    """Safely remove a file."""
    try:
        if os.path.exists(file_path):
            os.remove(file_path)
    except Exception:
        pass  # Ignore cleanup errors


def format_caption(original_link: str, description: str = "", max_length: int = 1024) -> str:
    """Format video caption with proper length limit."""
    platform_name = get_platform_name(original_link)
    caption = f'🔗 <a href="{original_link}">Open in {platform_name}</a>'

    if description and description.strip():
        caption += f'\n\n{description.strip()}'

    # Enforce Telegram limit
    if len(caption) > max_length:
        caption = caption[:max_length - 3] + "..."

    return caption
