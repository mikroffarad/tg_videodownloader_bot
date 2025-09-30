"""
Telegram Video Downloader Bot

A bot that downloads videos from various platforms (Instagram, YouTube, TikTok, etc.)
and provides options to customize the description.
"""

import asyncio
import logging
from dotenv import load_dotenv

from aiogram import Bot, Dispatcher
from aiogram.filters import Command
from aiogram import F

from src.config import BotConfig
from src.handlers import (
    VideoCallback,
    start_handler,
    download_video_handler,
    handle_video_callback
)

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


async def main():
    """Main function to run the bot."""
    try:
        # Load configuration
        config = BotConfig.from_env()

        # Initialize bot and dispatcher
        bot = Bot(token=config.bot_token)
        dp = Dispatcher()

        # Register handlers
        @dp.message(Command("start"))
        async def start_command_handler(message):
            await start_handler(message)

        @dp.message()
        async def download_message_handler(message):
            await download_video_handler(message, config)

        @dp.callback_query(VideoCallback.filter())
        async def video_callback_handler(callback_query, callback_data):
            await handle_video_callback(callback_query, callback_data)

        logger.info("🤖 Starting Telegram Video Downloader Bot...")
        logger.info(f"Bot token: ...{config.bot_token[-10:]}")

        # Start polling
        await dp.start_polling(bot)

    except Exception as e:
        logger.error(f"Failed to start bot: {e}")
        raise


if __name__ == "__main__":
    asyncio.run(main())
