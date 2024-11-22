Compare current hashes to baseline
$baseline = Import-Clixml -Path ".\BaselineHashes.xml"
foreach ($file in $files) {
    $currentHash = (Get-FileHash $file.FullName -Algorithm SHA256).Hash
    if ($baseline[$file.FullName] -ne $currentHash) {
        Write-Host "File changed: $($file.FullName)"
    }
}
