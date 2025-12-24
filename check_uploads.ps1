$p = Get-Content (Join-Path $PSScriptRoot 'index.html') -Raw
$matches = [regex]::Matches($p, '/wp-content/uploads/[^"\)\s]+') | ForEach-Object { $_.Value.Trim() } | Sort-Object -Unique
foreach ($rel in $matches) {
    $full = Join-Path $PSScriptRoot $rel.TrimStart('/')
    if (-not (Test-Path $full)) { Write-Output "MISSING: $rel" } else { Write-Output "OK: $rel" }
}
