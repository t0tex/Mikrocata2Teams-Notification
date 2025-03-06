# Mikrocata2Teams-Notification

This script (`teams_alert.sh`) is designed to monitor the `mikrocataTZSP0.service` for real-time alerts and send notifications to a Microsoft Teams channel via webhooks. The script checks logs continuously for newly blocked IP addresses, formats the data into structured alerts, and sends them directly to your Microsoft Teams channel for easy tracking and review.

This script works in conjunction with the [Mikrocata2SELKS](https://github.com/angolo40/mikrocata2selks) repository, which integrates Mikrotik IDS logs with SELKS for analysis and alerting.

---

## ⚠️ Required Modification for Proper Functionality

In order for this script to work correctly, you need to modify the `mikrocata.py` file to explicitly pull the blocked IP address. Without this change, the Teams notifications will not include the IP details needed for verification.

### Required Change in `mikrocata.py`:

Locate the `add_to_tik(alerts)` function and update the `print` statement as follows:

#### Previous Code:
```python
print(f"[Mikrocata] new ip added: {cmnt}")
```

#### Updated Code:
```python
print(f"[Mikrocata] new ip added: {wanted_ip} - {cmnt}")
```

### Why is This Necessary?
This modification ensures that the actual blocked IP address is captured and displayed in the notification. This allows for easier verification and tracking of suspicious activity.

### Example Teams Notification After Modification:

> 🚨 **New IP Blocked** 🚨  
> **🔹 Blocked IP:** `52.242.79.71`  
> **🔹 Rule:** `[1:2610608] TGI HUNT Unencrypted HTTP Authorization Header Outbound` :::  
> **🔹 Port:** `51987/TCP`  
> **🔹 Timestamp:** `6 Mar`  
>  
> 🔍 **Lookup Options:**  
> [🔹 Shodan Lookup](https://www.shodan.io/host/52.242.79.71)  
> [🔹 AbuseIPDB Check](https://www.abuseipdb.com/check/52.242.79.71)  
> [🔹 GreyNoise Lookup](https://viz.greynoise.io/ip/52.242.79.71)

### Applying the Change:

1. Open the `mikrocata.py` script:
   ```bash
   nano mikrocata.py
   ```
2. Locate the `add_to_tik(alerts)` function.
3. Replace the existing `print` statement with the updated one shown above.
4. Save the file and restart the script to apply changes.

---

## 📋 Dependencies

Before running the script, make sure you have the following tool installed:

- **jq** (for JSON processing):
  ```bash
  sudo apt install jq
  ```

- **Mikrocata2SELKS** ([Link](https://github.com/angolo40/mikrocata2selks)):
  Ensure Mikrocata2SELKS is correctly set up before proceeding.

---

## 🚀 Features

✅ **Automated Monitoring:** Automatically tracks logs for newly blocked IP addresses.  
✅ **Microsoft Teams Integration:** Sends formatted alerts directly to Microsoft Teams via webhook.  
✅ **Duplicate Prevention:** Avoids sending repeated alerts for the same blocked IP address.  
✅ **Systemd Service Support:** Runs in the background as a service for continuous monitoring.  
✅ **Logging Support:** Maintains logs for troubleshooting and tracking alerts sent.  

---

## 🔧 Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/t0tex/Mikrocata2Teams-Notification.git
   cd Mikrocata2Teams-Notification
   ```

2. **Edit the script and replace `WEBHOOK_URL` with your Teams webhook URL:**
   ```bash
   nano teams_alert.sh
   ```

3. **Make the script executable:**
   ```bash
   chmod +x teams_alert.sh
   ```

4. **(Optional) Set up a systemd service for continuous monitoring:**
   ```bash
   sudo cp teams_alert.service /etc/systemd/system/
   sudo systemctl daemon-reload
   sudo systemctl enable teams_alert.service
   sudo systemctl start teams_alert.service
   ```

---

## 📌 How It Works

- The script continuously monitors logs from `mikrocataTZSP0.service` using `journalctl`.
- When a new blocked IP is detected, it extracts key details such as the IP address, rule signature, and timestamp.
- These details are formatted into a JSON message that is sent to the Microsoft Teams Webhook URL.
- To prevent duplicate notifications, the script logs all sent alerts.

### 📬 Expected Output

> 🚨 **New IP Blocked** 🚨  
> **🔹 Blocked IP:** `52.242.79.71`  
> **🔹 Rule:** `[1:2610608] TGI HUNT Unencrypted HTTP Authorization Header Outbound` :::  
> **🔹 Port:** `51987/TCP`  
> **🔹 Timestamp:** `6 Mar`  
>  
> 🔍 **Lookup Options:**  
> [🔹 Shodan Lookup](https://www.shodan.io/host/52.242.79.71)  
> [🔹 AbuseIPDB Check](https://www.abuseipdb.com/check/52.242.79.71)  
> [🔹 GreyNoise Lookup](https://viz.greynoise.io/ip/52.242.79.71)

---

## 📂 Logs & Debugging

- **Alerts are logged to:** `/var/log/teams_alert.log`  
- **Errors are logged to:** `/var/log/teams_alert_error.log`  

To manually check service logs:
```bash
journalctl -u teams_alert.service -f
```

---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

---

## 📄 License

This project is licensed under the **MIT License**.
