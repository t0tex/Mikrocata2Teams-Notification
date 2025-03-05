Mikrocata2Teams-Notification

This script (teams_alert.sh) is designed to monitor the mikrocataTZSP0.service for real-time alerts and send notifications to a Microsoft Teams channel via webhooks. The script checks logs continuously for newly blocked IP addresses, formats the data into structured alerts, and sends them directly to your Microsoft Teams channel for easy tracking and review.

This script works in conjunction with the [Mikrocata2SELKS](https://github.com/angolo40/mikrocata2selks) repository, which integrates Mikrotik IDS logs with SELKS for analysis and alerting.
Dependencies

Before running the script, make sure you have the following tool installed:

    jq (for JSON processing):
        jq is used to format the message that will be sent to the Microsoft Teams webhook.

    Installation:

    sudo apt install jq

    Mikrocata2SELKS:
        This script works in conjunction with the Mikrocata2SELKS repository, which integrates Mikrotik IDS logs with SELKS for analysis and alerting.
        Be sure to have Mikrocata2SELKS set up before running this script.

Features

    ✅ Automated Monitoring: Automatically tracks logs for newly blocked IP addresses.
    ✅ Microsoft Teams Integration: Sends formatted alerts directly to Microsoft Teams via webhook.
    ✅ Duplicate Prevention: Avoids sending repeated alerts for the same blocked IP address.
    ✅ Systemd Service Support: Runs in the background as a service for continuous monitoring.
    ✅ Logging Support: Maintains logs for troubleshooting and tracking alerts sent.

Installation

    Clone the repository:

git clone https://github.com/t0tex/Mikrocata2Teams-Notification.git
cd Mikrocata2Teams-Notification

    Edit the script and replace WEBHOOK_URL with your Teams webhook URL:

nano teams_alert.sh

    Make the script executable:

chmod +x teams_alert.sh

    (Optional) Set up a systemd service for continuous monitoring:
        Copy the service file to the systemd directory:

sudo cp teams_alert.service /etc/systemd/system/

    Reload the systemd daemon to recognize the new service:

sudo systemctl daemon-reload

    Enable the service to start on boot:

sudo systemctl enable teams_alert.service

    Start the service:

    sudo systemctl start teams_alert.service

How It Works

    The script continuously monitors logs from mikrocataTZSP0.service using journalctl.
    When a new blocked IP is detected, it extracts key details such as the IP address, rule signature, and timestamp.
    These details are formatted into a JSON message that is sent to the Microsoft Teams Webhook URL.
    To prevent duplicate notifications, the script logs all sent alerts.

Expected Output

When the script detects a new blocked IP, a notification will be sent to your Microsoft Teams channel in the following format:

    🚨 **New IP Blocked** 🚨

    [Mikrocata] new ip added: [1:5000002] ETN AGGRESSIVE IPs Group 2 ::: Port: 443/TCP ::: timestamp: 5 Mar 2025 19:33:53.92107

The message will include the rule signature and timestamp, formatted for easy tracking.
Logs & Debugging

    Alerts are logged to /var/log/teams_alert.log.
    Errors are logged to /var/log/teams_alert_error.log.

You can manually check service logs for any issues with:

journalctl -u teams_alert.service -f

Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
License

This project is licensed under the MIT License.
