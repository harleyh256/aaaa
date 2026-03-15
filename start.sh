#!/bin/bash

# exit on error
set -o errexit

STORAGE_DIR=/opt/render/project/.render

if [[ ! -d $STORAGE_DIR/chrome ]]; then
  echo "...Downloading Chrome"
  mkdir -p $STORAGE_DIR/chrome
  cd $STORAGE_DIR/chrome
  wget -P ./ https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  dpkg -x ./google-chrome-stable_current_amd64.deb $STORAGE_DIR/chrome
  rm ./google-chrome-stable_current_amd64.deb
  cd $HOME/project/src # Make sure we return to where we were
else
  echo "...Using Chrome from cache"
fi

# be sure to add Chromes location to the PATH as part of your Start Command
# export PATH="${PATH}:/opt/render/project/.render/chrome/opt/google/chrome"

# add your own build commands...
# Start script for YouTube Viewer Bot

echo "🚀 Starting YouTube Viewer Bot..."

# Check if config exists
if [ ! -f ".env" ]; then
    echo "⚠️  No .env file found. Copying from config.env..."
    cp config.env .env
    echo "📝 Please edit .env file with your stream URL before running again!"
    exit 1
fi

# Load environment variables
source .env

# Validate stream URL
if [[ "$STREAM_URL" == *"YOUR_STREAM_ID"* ]]; then
    echo "❌ Please update STREAM_URL in .env file with your actual stream URL!"
    exit 1
fi

# Create necessary directories
mkdir -p logs chrome_profiles

# Start the bot
echo "🤖 Starting bot with $VIEWER_COUNT viewers..."
echo "📺 Stream: $STREAM_URL"

python main.py
