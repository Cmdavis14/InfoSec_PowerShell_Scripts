# Define variables
$directoryPath = "C:\CriticalFiles"
$outputPath = ".\BaselineHashes.xml"
$logFilePath = ".\HashingLog.txt"

# Initialize data structures
$hashes = @{}
$errors = @()

# Ensure the log file is clean at the start
if (Test-Path $logFilePath) {
    Remove-Item $logFilePath -Force
}
Add-Content -Path $logFilePath -Value "File Hashing Process Log - $(Get-Date)`n"

# Get all files in the specified directory
try {
    $files = Get-ChildItem -Path $directoryPath -Recurse -File
    Add-Content -Path $logFilePath -Value "Found $($files.Count) files in $directoryPath.`n"
} catch {
    Write-Host "Error: Unable to access directory $directoryPath."
    Add-Content -Path $logFilePath -Value "Error accessing directory: $_`n"
    exit
}

# Loop through each file and hash it
foreach ($file in $files) {
    try {
        $hash = (Get-FileHash $file.FullName -Algorithm SHA256).Hash
        $hashes[$file.FullName] = $hash
        Add-Content -Path $logFilePath -Value "Hashed file: $($file.FullName) - $hash"
    } catch {
        $errors += $file.FullName
        Add-Content -Path $logFilePath -Value "Error hashing file: $($file.FullName). Error: $_"
    }
}

# Save the baseline hashes to an XML file
try {
    $hashes | Export-Clixml -Path $outputPath
    Add-Content -Path $logFilePath -Value "Baseline saved to $outputPath.`n"
} catch {
    Write-Host "Error: Unable to save baseline to $outputPath."
    Add-Content -Path $logFilePath -Value "Error saving baseline: $_`n"
}

# Log errors, if any
if ($errors.Count -gt 0) {
    Add-Content -Path $logFilePath -Value "Files with errors: $($errors -join ', ')`n"
    Write-Host "Some files could not be hashed. Check $logFilePath for details."
} else {
    Add-Content -Path $logFilePath -Value "All files hashed successfully.`n"
}

Write-Host "Hashing process completed. Check $logFilePath for details."
