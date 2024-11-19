# Suspicious Process Monitoring Script
# Enhanced version with real-time monitoring, geolocation, logging, and alerting

# Define suspicious and allowed IP address lists
$denyList = @("203.0.113.0", "198.51.100.0")  # Example suspicious IPs
$allowList = @("10.0.0.0", "192.168.1.0")     # Example safe IPs
$logPath = ".\DetailedConnectionLog.csv"

# Initialize log file
if (-not (Test-Path $logPath)) {
    "Timestamp,LocalAddress,LocalPort,RemoteAddress,RemotePort,ProcessName,GeoLocation,Suspicious" | Out-File -FilePath $logPath
}

# Function to log connections to a file
function Log-Connection {
    param (
        [string]$timestamp,
        [string]$localAddress,
        [int]$localPort,
        [string]$remoteAddress,
        [int]$remotePort,
        [string]$processName,
        [string]$geoLocation,
        [bool]$isSuspicious
    )
    "$timestamp,$localAddress,$localPort,$remoteAddress,$remotePort,$processName,$geoLocation,$isSuspicious" | Out-File -FilePath $logPath -Append
}

# Function to get geolocation info for an IP address
function Get-Geolocation {
    param ([string]$ipAddress)
    try {
        $geoInfo = Invoke-RestMethod -Uri "https://ipinfo.io/$ipAddress/json" -ErrorAction Stop
        return "$($geoInfo.city), $($geoInfo.country)"
    } catch {
        return "Unknown"
    }
}

# Real-time monitoring
while ($true) {
    # Retrieve all active TCP connections
    Get-NetTCPConnection | ForEach-Object {
        # Retrieve process information
        $Process = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue

        # Determine geolocation for the remote address
        $geoLocation = if ($_.RemoteAddress -notmatch "^(0|127|::1)") {  # Exclude local loopback addresses
            Get-Geolocation $_.RemoteAddress
        } else {
            "Local"
        }

        # Check if the connection is suspicious
        $isSuspicious = $denyList -contains $_.RemoteAddress

        # Output details to the console
        [PSCustomObject]@{
            Timestamp      = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            LocalAddress   = $_.LocalAddress
            LocalPort      = $_.LocalPort
            RemoteAddress  = $_.RemoteAddress
            RemotePort     = $_.RemotePort
            ProcessName    = $Process?.ProcessName
            GeoLocation    = $geoLocation
            Suspicious     = $isSuspicious
        } | Format-Table -AutoSize

        # Log details to a file
        Log-Connection -timestamp (Get-Date).ToString("yyyy-MM-dd HH:mm:ss") `
                       -localAddress $_.LocalAddress `
                       -localPort $_.LocalPort `
                       -remoteAddress $_.RemoteAddress `
                       -remotePort $_.RemotePort `
                       -processName $Process?.ProcessName `
                       -geoLocation $geoLocation `
                       -isSuspicious $isSuspicious

        # Alert for suspicious connections
        if ($isSuspicious) {
            Write-Host "Suspicious connection detected: $($_.RemoteAddress)" -ForegroundColor Red

            # Optional: Pop-up alert
            Add-Type -AssemblyName System.Windows.Forms
            [System.Windows.Forms.MessageBox]::Show("Suspicious connection to $($_.RemoteAddress)", "Alert")

            # Optional: Email alert (requires SMTP configuration)
            # Send-MailMessage -To "admin@example.com" -From "alert@example.com" -Subject "Suspicious Connection Detected" `
            # -Body "A connection to $($_.RemoteAddress) was flagged." -SmtpServer "smtp.example.com"
        }
    }

    # Refresh every 10 seconds
    Start-Sleep -Seconds 10
}
