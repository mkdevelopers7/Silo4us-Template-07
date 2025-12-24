$root = 'd:\Clone Sites\www.equiduct.com\www.equiduct.com'
$prefix = 'http://localhost:9000/'
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($prefix)
$listener.Start()
Write-Output "Serving $root at http://localhost:9000/ (Ctrl-C to stop)"
while ($true) {
    $context = $listener.GetContext()
    $req = $context.Request
    $urlPath = $req.Url.AbsolutePath.TrimStart('/')
    if ([string]::IsNullOrEmpty($urlPath)) { $urlPath = 'index.html' }
    $file = Join-Path $root $urlPath
    if (-not (Test-Path $file)) {
        $context.Response.StatusCode = 404
        $buffer = [System.Text.Encoding]::UTF8.GetBytes('404 Not Found')
        $context.Response.OutputStream.Write($buffer,0,$buffer.Length)
        $context.Response.Close()
        continue
    }
    $bytes = [System.IO.File]::ReadAllBytes($file)
    $ext = [System.IO.Path]::GetExtension($file).ToLowerInvariant()
    switch ($ext) {
        '.html' { $type='text/html' }
        '.htm' { $type='text/html' }
        '.css' { $type='text/css' }
        '.js' { $type='application/javascript' }
        '.png' { $type='image/png' }
        '.jpg' { $type='image/jpeg' }
        '.jpeg' { $type='image/jpeg' }
        '.svg' { $type='image/svg+xml' }
        '.webp' { $type='image/webp' }
        '.gif' { $type='image/gif' }
        '.json' { $type='application/json' }
        default { $type='application/octet-stream' }
    }
    $context.Response.ContentType = $type
    $context.Response.ContentLength64 = $bytes.Length
    $context.Response.OutputStream.Write($bytes,0,$bytes.Length)
    $context.Response.Close()
}