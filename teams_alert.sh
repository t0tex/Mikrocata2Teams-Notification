#!/bin/bash

# Microsoft Teams Webhook URL (Replace with your actual webhook)
WEBHOOK_URL="https://your-teams-webhook-url"

# Lock file to prevent multiple instances
LOCK_FILE="/tmp/teams_alert.lock"

# Check if script is already running
if pgrep -f "teams_alert.sh" | grep -v $$; then
    echo "Script is already running. Exiting."
    exit 1
fi

# Monitor journal logs for new IPs
journalctl -u mikrocataTZSP0.service -f | while read -r line; do
    if echo "$line" | grep -q "new ip added"; then
        # Extract relevant details
        IP_INFO=$(echo "$line" | grep -oP '\[Mikrocata\] new ip added:.*')

        # Avoid duplicate messages
        LOG_FILE="/tmp/teams_alert_sent.log"
        if grep -q "$IP_INFO" "$LOG_FILE"; then
            continue  # Skip duplicate messages
        fi

        # Log the message to prevent duplicates
        echo "$IP_INFO" >> "$LOG_FILE"

        # Format message correctly
        JSON_PAYLOAD=$(jq -n \
            --arg text "🚨 **New IP Blocked** 🚨\n\n$IP_INFO" \
            '{text: $text | gsub("\\\\n"; "\n")}')

        # Send to Teams
        curl -H "Content-Type: application/json" -d "$JSON_PAYLOAD" "$WEBHOOK_URL"
    fi
done
