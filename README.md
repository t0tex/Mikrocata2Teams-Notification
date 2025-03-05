Mikrocata2Teams-Notification

This script (teams_alert.sh) is designed to monitor the mikrocataTZSP0.service alerts and send real-time notifications to a Microsoft Teams channel via webhooks. It works by continuously checking logs for newly blocked IP addresses and formatting them into a structured alert for easy review.

Features

✅ Automated Monitoring – Tracks logs for new blocked IP addresses.
✅ Microsoft Teams Integration – Sends alerts directly to Teams via webhook.
✅ Duplicate Prevention – Avoids sending repeated alerts for the same IP.
✅ Systemd Service Support – Runs in the background as a service.
✅ Logging Support – Maintains logs for troubleshooting and tracking.

Installation

Clone the repository:

git clone https://github.com/your-username/Mikrocata2Teams-Notification.git
cd Mikrocata2Teams-Notification

Edit the script and replace WEBHOOK_URL with your Teams webhook URL:

nano teams_alert.sh

Make the script executable:

chmod +x teams_alert.sh

(Optional) Set up a systemd service for continuous monitoring:

sudo cp teams_alert.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable teams_alert.service
sudo systemctl start teams_alert.service

How It Works

The script monitors logs from mikrocataTZSP0.service using journalctl.

When a new blocked IP is detected, it extracts relevant details (IP, rule signature, timestamp).

The extracted data is formatted into a JSON message for Microsoft Teams.

The message is sent to the configured Teams Webhook URL.

The script logs sent alerts to prevent duplicate messages.

Logs & Debugging

The script logs all alerts in /var/log/teams_alert.log.

Errors are logged in /var/log/teams_alert_error.log.

You can manually check service logs:

journalctl -u teams_alert.service -f

Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

License

This project is licensed under the MIT License.

🚀 Enjoy real-time security alerts in Microsoft Teams!
