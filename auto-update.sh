#!/usr/bin/env bash

LOG="/var/log/auto-update.log"

# Prevent overlapping runs
if [ -f /var/lock/auto-update.lock ]; then
    echo "[$(date)] Skipped: another update is already running." >> "$LOG"
    exit 0
fi
touch /var/lock/auto-update.lock

echo "[$(date)] === Update started ===" >> "$LOG"

# Refresh DB and upgrade all packages without prompting
echo "========================================"
echo "  Welcome back, $USER!"
echo "  $(date)"
echo "  Updating your PC...."
echo "========================================"
pacman -Syu --noconfirm 2>&1 >> "$LOG"

STATUS=$?

# Clean up orphaned packages
if [ $STATUS -eq 0 ]; then
    pacman -Rns --noconfirm $(pacman -Qtdq) >> "$LOG" 2>&1
fi

echo "[$(date)] === Update finished (exit $STATUS) ===" >> "$LOG"
rm -f /var/lock/auto-update.lock
