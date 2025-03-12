#!/bin/bash

# File to store the last displayed news
NEWS_FILE="$HOME/.cache/arch_news_last"
STATE_FILE="$HOME/.cache/arch_news_read"  # New file to track read state

# URL for Arch Linux News RSS feed
FEED_URL="https://archlinux.org/feeds/news/"

# Function to fetch the latest news
fetch_news() {
    curl -s "$FEED_URL" | grep -oP '(?<=<title>).*?(?=</title>)' | sed '1d' | head -n 1
}

# If called with "clear", mark as read
if [ "$1" == "clear" ]; then
    echo "" > "$NEWS_FILE"
    touch "$STATE_FILE"  # Mark the news as read by creating the file
    polybar-msg action "#arch_news.hook.0"  # Trigger Polybar refresh after clearing news
    exit 0
fi

# If we have marked the news as read, show "all caught up"
if [ -f "$STATE_FILE" ]; then
    echo "" #✅ Up-to-date
    exit 0
fi

# Fetch or read cached news
if [ ! -f "$NEWS_FILE" ] || [ -z "$(cat "$NEWS_FILE")" ]; then
    news=$(fetch_news)
    echo "$news" > "$NEWS_FILE"

else
    news=$(cat "$NEWS_FILE")
fi

# If no news, show nothing
if [ -z "$news" ]; then
    exit 0
fi

# Highlight if manual intervention is needed
if echo "$news" | grep -iq "manual"; then
    echo "⚠️ --- $news --- ⚠️"
else
    echo "📰 $news"
fi
