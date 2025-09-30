"""
Handlers module for the Telegram Video Downloader Bot.
"""

import os
import yt_dlp
from aiogram import types
from aiogram.types import InlineKeyboardMarkup, InlineKeyboardButton, FSInputFile
from aiogram.filters.callback_data import CallbackData
import base64
import hashlib

from .config import BotConfig
from .utils import resolve_share_url, format_caption, ensure_downloads_dir, cleanup_file, get_platform_name

# Store URLs temporarily using hash as key
_url_cache = {}

def cleanup_old_cache():
    """Clean up old URLs from cache to prevent memory leaks."""
    # Keep only last 100 URLs to prevent memory issues
    if len(_url_cache) > 100:
        # Remove oldest entries (this is a simple approach)
        keys_to_remove = list(_url_cache.keys())[:-50]  # Keep last 50
        for key in keys_to_remove:
            _url_cache.pop(key, None)

class VideoCallback(CallbackData, prefix="video"):
    action: str
    url_id: str  # Hash ID instead of full URL


def create_video_keyboard(original_link: str) -> InlineKeyboardMarkup:
    """Create inline keyboard with description options."""
    # Clean up cache periodically
    cleanup_old_cache()

    # Create a short hash for the URL and store it in cache
    url_id = hashlib.md5(original_link.encode()).hexdigest()[:16]
    _url_cache[url_id] = original_link

    keyboard = InlineKeyboardMarkup(inline_keyboard=[
        [
            InlineKeyboardButton(
                text="✅ Keep caption",
                callback_data=VideoCallback(action="keep", url_id=url_id).pack()
            ),
            InlineKeyboardButton(
                text="❌ Clear caption",
                callback_data=VideoCallback(action="remove", url_id=url_id).pack()
            )
        ]
    ])
    return keyboard
async def start_handler(message: types.Message):
    """Handle /start command."""
    await message.answer(
        "🎥 <b>Telegram Video Downloader Bot</b>\n\n"
        "Send me a video link from:\n"
        "• Instagram\n"
        "• YouTube\n"
        "• TikTok\n"
        "• And many other platforms!\n\n"
        "I'll download it and send it back to you with options to customize the description.",
        parse_mode="HTML"
    )


async def download_video_handler(message: types.Message, config: BotConfig):
    """Handle video download requests."""
    url = message.text.strip()
    if not url.startswith("http"):
        await message.answer("Please send me a valid URL.")
        return

    status_message = await message.answer("📥 Downloading video... Please wait ⏳")

    try:
        # Ensure downloads directory exists
        ensure_downloads_dir(config.downloads_dir)

        # Resolve share URL
        url = resolve_share_url(url)

        # Configure yt-dlp
        ydl_opts = config.get_ydl_opts()

        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            info = ydl.extract_info(url, download=True)
            file_path = ydl.prepare_filename(info)

        description = info.get("description") or info.get("title", "")
        original_link = info.get("webpage_url", url)

        # Format caption
        caption = format_caption(original_link, description, config.caption_max_length)

        # Prepare video file
        video = FSInputFile(file_path)

        # Create keyboard if there's description
        keyboard = None
        if description and description.strip():
            keyboard = create_video_keyboard(original_link)

        # Send video
        await message.answer_video(
            video=video,
            caption=caption,
            parse_mode="HTML",
            reply_markup=keyboard
        )

        # Delete original messages
        try:
            await message.delete()
            await status_message.delete()
        except Exception:
            # Ignore errors if messages are already deleted or bot doesn't have permissions
            pass

        # Clean up downloaded file
        cleanup_file(file_path)

    except Exception as e:
        error_message = f"❌ Error downloading video: {str(e)}"
        await status_message.edit_text(error_message)


async def handle_video_callback(callback_query: types.CallbackQuery, callback_data: VideoCallback):
    """Handle video description options."""
    try:
        original_message = callback_query.message

        # Get URL from cache using the hash ID
        original_link = _url_cache.get(callback_data.url_id)
        if not original_link:
            await callback_query.answer("❌ Link isn't available anymore", show_alert=True)
            return

        platform_name = get_platform_name(original_link)

        if callback_data.action == "keep":
            # Just remove the keyboard, keep the description
            await original_message.edit_reply_markup(reply_markup=None)
            await callback_query.answer("✅ Caption kept")

        elif callback_data.action == "remove":
            # Remove description, keep only the link
            new_caption = f'🔗 <a href="{original_link}">Open in {platform_name}</a>'

            await original_message.edit_caption(
                caption=new_caption,
                parse_mode="HTML",
                reply_markup=None
            )
            await callback_query.answer("✅ Caption cleared")

        # Clean up cache after use
        _url_cache.pop(callback_data.url_id, None)

    except Exception as e:
        await callback_query.answer(f"❌ Error: {str(e)}", show_alert=True)
