#!/bin/bash

# Microsoft Teams Webhook URL (Replace with your actual webhook)
WEBHOOK_URL="https://your-teams-webhook-url"

# Lock file to prevent multiple instances
LOCK_FILE="/tmp/teams_alert.lock"

echo "Checking if lock file exists..."

# Check if lock file exists, indicating the script is already running
if [ -e "$LOCK_FILE" ]; then
    # Check if the script is still running
    PID=$(cat "$LOCK_FILE")
    if ps -p $PID > /dev/null; then
        echo "Script is already running (PID $PID). Exiting." | tee -a /var/log/teams_alert_error.log
        exit 1
    else
        echo "Stale lock file found, removing..." | tee -a /var/log/teams_alert_error.log
        rm -f "$LOCK_FILE"
    fi
fi

# Create the lock file with the current script's PID
echo $$ > "$LOCK_FILE"

# Ensure the lock file is removed when the script exits
trap "rm -f $LOCK_FILE" EXIT

echo "Lock file created. Script will now monitor logs..."

# Monitor journal logs for new IPs
journalctl -u mikrocataTZSP0.service -f | while read -r line; do
    if echo "$line" | grep -q "new ip added"; then
        # Extract relevant details
        IP_INFO=$(echo "$line" | grep -oP '\[Mikrocata\] new ip added:.*')

        # Avoid duplicate messages
        LOG_FILE="/var/log/teams_alert_sent.log"
        if grep -q "$IP_INFO" "$LOG_FILE"; then
            continue  # Skip duplicate messages
        fi

        # Log the message to prevent duplicates
        echo "$IP_INFO" >> "$LOG_FILE"

        # Log the information that will be sent to Teams
        JSON_PAYLOAD=$(jq -n \
            --arg text "🚨 **New IP Blocked** 🚨\n\n$IP_INFO" \
            '{text: $text | gsub("\\\\n"; "\n")}')

        # Log the exact payload that will be sent to Teams into the log file
        echo "Sending the following message to Teams: $JSON_PAYLOAD" | tee -a /var/log/teams_alert.log

        # Send to Teams
        curl -H "Content-Type: application/json" -d "$JSON_PAYLOAD" "$WEBHOOK_URL" 2>> /var/log/teams_alert_error.log
    fi
done
