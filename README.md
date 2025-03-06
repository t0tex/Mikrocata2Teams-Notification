Mikrocata2Teams-Notification

This script (teams_alert.sh) is designed to monitor the mikrocataTZSP0.service for real-time alerts and send notifications to a Microsoft Teams channel via webhooks. The script checks logs continuously for newly blocked IP addresses, formats the data into structured alerts, and sends them directly to your Microsoft Teams channel for easy tracking and review.

This script works in conjunction with the Mikrocata2SELKS repository, which integrates Mikrotik IDS logs with SELKS for analysis and alerting.

⚠️ Required Modification for Proper Functionality

In order for this script to work correctly, you need to modify the mikrocata.py file to explicitly pull the blocked IP address. Without this change, the Teams notifications will not include the IP details needed for verification.

Required Change in mikrocata.py:

Locate the add_to_tik(alerts) function and update the print statement as follows:

Previous Code:

print(f"[Mikrocata] new ip added: {cmnt}")

Updated Code:

print(f"[Mikrocata] new ip added: {wanted_ip} - {cmnt}")

Why is This Necessary?

This modification ensures that the actual blocked IP address is captured and displayed in the notification. This allows for easier verification and tracking of suspicious activity.

Example Teams Notification After Modification:

🚨 New IP Blocked 🚨🔹 Blocked IP: 52.242.79.71🔹 Rule: [1:2610608] TGI HUNT Unencrypted HTTP Authorization Header Outbound :::🔹 Port: 51987/TCP🔹 Timestamp: 6 Mar

🔍 Lookup Options:🔹 Shodan Lookup🔹 AbuseIPDB Check🔹 GreyNoise Lookup

To apply this change:

Open the mikrocata.py script:

nano mikrocata.py

Locate the add_to_tik(alerts) function.

Replace the existing print statement with the updated one shown above.

Save the file and restart the script to apply changes.

This ensures that your Microsoft Teams notifications provide full details, including the blocked IP for verification and further action.

📋 Dependencies

Before running the script, make sure you have the following tool installed:

jq (for JSON processing):

sudo apt install jq

Mikrocata2SELKS (Link):
Ensure Mikrocata2SELKS is correctly set up before proceeding.

🚀 Features

✅ Automated Monitoring: Automatically tracks logs for newly blocked IP addresses.✅ Microsoft Teams Integration: Sends formatted alerts directly to Microsoft Teams via webhook.✅ Duplicate Prevention: Avoids sending repeated alerts for the same blocked IP address.✅ Systemd Service Support: Runs in the background as a service for continuous monitoring.✅ Logging Support: Maintains logs for troubleshooting and tracking alerts sent.

🔧 Installation

Clone the repository:

git clone https://github.com/t0tex/Mikrocata2Teams-Notification.git
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

📌 How It Works

The script continuously monitors logs from mikrocataTZSP0.service using journalctl.

When a new blocked IP is detected, it extracts key details such as the IP address, rule signature, and timestamp.

These details are formatted into a JSON message that is sent to the Microsoft Teams Webhook URL.

To prevent duplicate notifications, the script logs all sent alerts.

📬 Expected Output

When the script detects a new blocked IP, a notification will be sent to your Microsoft Teams channel in the following format:

🚨 New IP Blocked 🚨🔹 Blocked IP: 52.242.79.71🔹 Rule: [1:2610608] TGI HUNT Unencrypted HTTP Authorization Header Outbound :::🔹 Port: 51987/TCP🔹 Timestamp: 6 Mar

🔍 Lookup Options:🔹 Shodan Lookup🔹 AbuseIPDB Check🔹 GreyNoise Lookup

📂 Logs & Debugging

Alerts are logged to: /var/log/teams_alert.log

Errors are logged to: /var/log/teams_alert_error.log

To manually check service logs:

journalctl -u teams_alert.service -f

🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

📄 License

This project is licensed under the MIT License.

