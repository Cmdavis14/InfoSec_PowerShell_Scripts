 # Log Analysis and Monitoring Script
   # This script analyzes Windows Event Logs to identify login failures (Event ID 4625).
   # The output is exported to a CSV file for easy analysis.

   # Retrieve failed login events from the Security log
   Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4625} |  
       Select-Object TimeCreated, Message |  
       Export-Csv -Path .\FailedLogons.csv -NoTypeInformation

   # Output a success message to the console
   Write-Host "Log analysis complete. Failed login events have been exported to FailedLogons.csv." -ForegroundColor Green
