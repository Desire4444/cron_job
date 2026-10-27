Summary: Hourly (Every 3 Hours) Auto-Update Cron Job on CachyOS
# NOTE:
I am working on cacchyos so the package maneger I am using is pacman -S is for installing.

# 1. Install & Enable Cron
```
sudo pacman -S cronie
sudo systemctl enable --now cronie
```
# 2. Create the Script
sudo nano /usr/local/bin/auto-update.sh
[//] # (Use a text EDITOR of choice and export it to defualt)

```
#!/usr/bin/env bash
LOG="/var/log/auto-update.log"

if [ -f /var/lock/auto-update.lock ]; then
    echo "[$(date)] Skipped: already running." >> "$LOG"
    exit 0
fi
touch /var/lock/auto-update.lock

echo "========================================"
echo "  Welcome back, $USER!"
echo "  $(date)"
echo "  Updating your PC!......."
echo "========================================"

echo "[$(date)] === Update started ===" >> "$LOG"
pacman -Syu --noconfirm 2>&1 >> "$LOG"
STATUS=$?

if [ $STATUS -eq 0 ]; then
    pacman -Rns --noconfirm $(pacman -Qtdq) >> "$LOG" 2>&1
fi

echo "[$(date)] === Update finished (exit $STATUS) ===" >> "$LOG"
rm -f /var/lock/auto-update.lock
```

### make it executable
`sudo chmod +x /usr/local/bin/auto-update.sh`

# 3. Add the Cron Job
`sudo EDITOR=nano crontab -e`

## Add:
`0 */3 */2 * * /usr/local/bin/auto-update.sh`

# 4. Verify
```
sudo crontab -l
cat /var/log/auto-update.log
```

#  5.Remove just the job
`sudo EDITOR=nano crontab -e`

### Delete the line:
`0 */3 */2 * * /usr/local/bin/auto-update.sh`

# 5b.Remove root's entire crontab (if that was the only job)
`sudo crontab -r`

# 5c.Also clean up the script and log
```
sudo rm /usr/local/bin/auto-update.sh
sudo rm /var/log/auto-update.log
```
