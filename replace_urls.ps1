$patterns = @(
    @{from='https://www.equiduct.com/wp-content'; to='/wp-content'},
    @{from='https://www.equiduct.com/wp-includes'; to='/wp-includes'},
    @{from='http://www.equiduct.com/wp-content'; to='/wp-content'},
    @{from='http://www.equiduct.com/wp-includes'; to='/wp-includes'}
)

$files = Get-ChildItem -Path $PSScriptRoot -Recurse -Include '*.html','*.css','*.js' | Sort-Object FullName
if (-not $files) { Write-Error "No target files found under $PSScriptRoot"; exit 1 }

$grandTotal = 0
foreach ($file in $files) {
    $text = Get-Content $file.FullName -Raw -Encoding UTF8
    $orig = $text
    $fileTotal = 0
    foreach ($p in $patterns) {
        $escaped = [regex]::Escape($p.from)
        $count = ([regex]::Matches($text, $escaped)).Count
        if ($count -gt 0) {
            $text = [regex]::Replace($text, $escaped, [System.Text.RegularExpressions.Regex]::Escape($p.to))
            $fileTotal += $count
        }
    }
    if ($fileTotal -gt 0) {
        Copy-Item $file.FullName "$($file.FullName).bak" -Force
        Set-Content -Path $file.FullName -Value $text -Encoding UTF8
        Write-Output "[$($file.Name)] Replaced $fileTotal occurrences (backup: $($file.Name).bak)"
        $grandTotal += $fileTotal
    }
}
Write-Output "Total replacements: $grandTotal"
