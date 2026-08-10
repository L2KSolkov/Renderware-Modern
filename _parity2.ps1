$ref = "D:\RW_372_src\reference\generated-headers-3.7.2"
$got = "D:\RW_372_src\build-d3d9\include\d3d9"

function Normalize($text) {
    $lines = $text -split "`r?`n"
    $out = New-Object System.Collections.Generic.List[string]
    foreach ($line in $lines) {
        if ($line -match '^\s*\*\s*Filename: <.*>$') { continue }
        if ($line -match '^\s*\*\s*Automatically Generated on:') { continue }
        $l = $line -replace [regex]::Escape('C:/RW/Graphics/rwsdk/'), 'RWSDK/' -replace [regex]::Escape('c:/RW/Graphics/rwsdk/'), 'RWSDK/' -replace [regex]::Escape('D:/RW_372_src/RWSDK/'), 'RWSDK/' -replace [regex]::Escape('d:/RW_372_src/RWSDK/'), 'RWSDK/'
        $out.Add($l)
    }
    return ($out -join "`n")
}

$mismatch = @()
foreach ($rf in Get-ChildItem -LiteralPath $ref -File) {
    $gf = Join-Path $got $rf.Name
    if (-not (Test-Path -LiteralPath $gf)) { $mismatch += "MISSING: $($rf.Name)"; continue }
    $r = Normalize ((Get-Content -LiteralPath $rf.FullName -Raw))
    $g = Normalize ((Get-Content -LiteralPath $gf -Raw))
    if ($r -cne $g) { $mismatch += "DIFF: $($rf.Name)" }
}
Write-Output "mismatches: $($mismatch.Count)"
$mismatch | Select-Object -First 40
