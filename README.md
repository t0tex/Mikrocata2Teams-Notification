# Mikrocata2Teams-Notification
This script (teams_alert.sh) is designed to monitor the mikrocataTZSP0.service alerts and send real-time notifications to a Microsoft Teams channel via webhooks. It works by continuously checking logs for newly blocked IP addresses and formatting them into a structured alert for easy review.
# Mikrocata Teams Notification
This script monitors Suricata IDS/IPS alerts and sends notifications to Microsoft Teams.

## Installation
1. Edit the script and replace `WEBHOOK_URL` with your Teams webhook.
2. Make the script executable:
   ```bash
   chmod +x teams_alert.sh
