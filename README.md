# InfoSec_Powershell_Scripts

## Overview  
This repository contains PowerShell scripts designed for information security professionals. The scripts focus on tasks such as log analysis, monitoring, and automation to enhance system security and streamline workflows.

---

## Scripts  

### 1. FailedLogons.ps1 

**Description:**  
The `Failed Logons` script analyzes Windows Event Logs for anomalies or specific event IDs. Currently, it focuses on detecting login failures by extracting `Event ID 4625` from the Security log. This script helps identify unauthorized access attempts and can serve as a foundation for further log analysis or integration into SIEM solutions.

**Functionality:**  
- Retrieves login failure events from the Security log.  
- Exports the extracted data, including time of occurrence and details, into a `.csv` file in scripts directory for further analysis.

**Source Code:**
Source code is located [here](Log_Analysis/FailedLogons.ps1).

### 2. Suspicious_Processes.ps1

**Description:**  
The Suspicious Process script is designed to monitor active TCP connections on a Windows system. It continuously checks the system for suspicious incoming or outgoing connections, flags potential threats based on a predefined list of suspicious IPs, and provides detailed real-time monitoring and alerts.
This script fetches process details associated with each network connection, logs the information to a CSV file, and provides geolocation data for remote IPs. If a suspicious connection is detected, the script generates real-time alerts, displays a message box, and can be configured to send email

**Functionality:**  
- Connection Monitoring:Monitors all active TCP connections on the system, uses Get-NeTCPConnection cmdlet to fetch info about IPs, ports, and the process associated with the connection.
- Suspicious IP Detection: compares the remote IP address of each connection against a deny list, if in deny list, its flagged as suspicious.
- Geolocation Lookup: For each suspicious connection, the script preforms a geo-lookup to provide the city and country of the remote address using ipinfo.io API.
- Logging: logs details to a CSV file (DetailedConnectionLog.csv)
- Real-Time Alerts: If suspicious connection is detected, the script will: output red alert to console, and display pop-up alert. 
- Real-Time Monitoring: The script runs in a loop and updates every 10 seconds to provide continuous monitoring of the network connections. 
**Use Cases:**
- Real-Time Threat Detection
- Network Security Monitoring
- Geolocaiton-Based Alerting

**Source Code:**
Source code is located [here](Monitoring/Suspicious_Processes.ps1).
