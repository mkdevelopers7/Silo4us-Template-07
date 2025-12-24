$missingFile = Join-Path $PSScriptRoot 'missing_uploads.txt'
if (-not (Test-Path $missingFile)) { Write-Error "missing_uploads.txt not found. Run check_uploads.ps1 first."; exit 1 }
$out = Join-Path $PSScriptRoot 'download_results.txt'
Remove-Item $out -ErrorAction SilentlyContinue

Get-Content $missingFile | ForEach-Object {
    if ($_ -match '^MISSING:\s*(.+)') {
        $rel = $Matches[1].Trim()
        # remove any trailing backslashes or stray characters
        $rel = $rel -replace '\\$','' -replace '\\',''
        $url = "https://www.equiduct.com$rel"
        $localPath = Join-Path $PSScriptRoot $rel.TrimStart('/')
        $dir = Split-Path $localPath -Parent
        if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
        try {
            Invoke-WebRequest -Uri $url -OutFile $localPath -UseBasicParsing -ErrorAction Stop
            "$rel -> OK" | Out-File -FilePath $out -Append -Encoding UTF8
        } catch {
            "$rel -> FAIL: $($_.Exception.Message)" | Out-File -FilePath $out -Append -Encoding UTF8
        }
    }
}

"Download complete. See download_results.txt" | Write-Output
