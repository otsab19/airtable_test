# Get available Windows Updates
$updates = Get-WUList -Online

# Loop through each update
foreach ($update in $updates) {
    # Check if the update is available for download
    if ($update.IsInstalled -eq $false -and $update.HasUpdateFile -eq $true) {
        # Download the update
        Write-Host "Downloading update: $($update.Title)"
        $downloadPath = Join-Path $env:TEMP -ChildPath "$($update.Title).msu"

        try {
            # Download update file to temp directory
            $wc = New-Object System.Net.WebClient
            $wc.DownloadFile($update.DownloadUri, $downloadPath)
            Write-Host "Update downloaded to: $downloadPath"

            # Install the downloaded update
            Start-Process -FilePath $downloadPath -ArgumentList "/quiet /norestart" -Wait -NoNewWindow
            Write-Host "Update installed successfully."

        } catch {
            Write-Host "Error downloading or installing update: $($_.Exception.Message)"
        }
    }
}

Write-Host "All available Windows Updates downloaded and installed."
