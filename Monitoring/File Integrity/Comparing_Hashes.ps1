# Define paths
$directoryPath = "C:\CriticalFiles"
$baselinePath = ".\BaselineHashes.xml"

# Ensure baseline exists
if (-Not (Test-Path $baselinePath)) {
    Write-Host "Error: Baseline file not found at $baselinePath."
    exit
}

# Load baseline hashes
$baseline = Import-Clixml -Path $baselinePath

# Get current files and hashes
try {
    $files = Get-ChildItem -Path $directoryPath -Recurse -File
} catch {
    Write-Host "Error: Unable to access directory $directoryPath."
    exit
}

# Compare current hashes to baseline
foreach ($file in $files) {
    $currentHash = (Get-FileHash $file.FullName -Algorithm SHA256).Hash
    if (-Not $baseline.ContainsKey($file.FullName)) {
        Write-Host "New file detected: $($file.FullName)"
    } elseif ($baseline[$file.FullName] -ne $currentHash) {
        Write-Host "File changed: $($file.FullName)"
    }
}

# Check for deleted files
$baselineFiles = $baseline.Keys
$currentFiles = $files.FullName
$deletedFiles = $baselineFiles | Where-Object { $_ -notin $currentFiles }

foreach ($deletedFile in $deletedFiles) {
    Write-Host "File deleted: $deletedFile"
}
