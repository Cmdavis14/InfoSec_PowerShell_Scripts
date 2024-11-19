# InfoSec_Powershell_Scripts

## Overview  
This repository contains PowerShell scripts designed for information security professionals. The scripts focus on tasks such as log analysis, monitoring, and automation to enhance system security and streamline workflows.

---

## Scripts  

### 1. Log Analysis and Monitoring  

**Description:**  
The `Log Analysis and Monitoring` script analyzes Windows Event Logs for anomalies or specific event IDs. Currently, it focuses on detecting login failures by extracting `Event ID 4625` from the Security log. This script helps identify unauthorized access attempts and can serve as a foundation for further log analysis or integration into SIEM solutions.

**Functionality:**  
- Retrieves login failure events from the Security log.  
- Exports the extracted data, including time of occurrence and details, into a `.csv` file in scripts directory for further analysis.

**Source Code:**
Source code is located [here](Log_Analysis_&_Monitoring).
