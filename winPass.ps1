# Simple PowerShell script for Windows credential hunting without much garbage output
# PS C:\Users\matrix\Desktop> .\winPass.ps1 or just copy and paste the code into the terminal

# One-liner:
# Get-ChildItem -Recurse -Include *.txt, *.ini, *.cfg, *.config, *.xml, *.ps1 -ErrorAction SilentlyContinue | ForEach-Object { $filename = $_.FullName; Select-String -Pattern "password" -Path $_.FullName -CaseSensitive -SimpleMatch -ErrorAction SilentlyContinue | ForEach-Object { Write-Host $filename -ForegroundColor Cyan; $line = $_.Line; $passwordIndex = $line.IndexOf("password"); $startIndex = [Math]::Max(0, $passwordIndex - 100); $endIndex = [Math]::Min($line.Length - 1, $passwordIndex + 100); $context = $line.Substring($startIndex, $endIndex - $startIndex + 1); if ($startIndex -gt 0) { $context = "Line $($_.LineNumber): ..." + $context } else { $context = "Line $($_.LineNumber): " + $context }; if ($endIndex -lt ($line.Length - 1)) { $context += "..." }; $context -split "(password)" | ForEach-Object { if ($_ -match "password") { Write-Host -NoNewline $_ -ForegroundColor Red } else { Write-Host -NoNewline $_ } }; Write-Host } }

Set-Location \
Get-ChildItem -Recurse -Include *.txt, *.ini, *.cfg, *.config, *.xml, *.ps1 -ErrorAction SilentlyContinue | ForEach-Object {
    $filename = $_.FullName

    Select-String -Pattern "password" -Path $_.FullName -CaseSensitive -SimpleMatch -ErrorAction SilentlyContinue | ForEach-Object {

        Write-Host $filename -ForegroundColor Cyan

        $line = $_.Line
        $passwordIndex = $line.IndexOf("password")
        $startIndex = [Math]::Max(0, $passwordIndex - 100)
        $endIndex = [Math]::Min($line.Length - 1, $passwordIndex + 100)
        $context = $line.Substring($startIndex, $endIndex - $startIndex + 1)
        
        if ($startIndex -gt 0) {
            $context = "Line $($_.LineNumber): ..." + $context
        } else {
            $context = "Line $($_.LineNumber): " + $context
        }
        
        if ($endIndex -lt ($line.Length - 1)) {
            $context += "..."
        }
        
        $context -split "(password)" | ForEach-Object {
            if ($_ -match "password") {
                Write-Host -NoNewline $_ -ForegroundColor Red
            } else {
                Write-Host -NoNewline $_
            }
        }
        Write-Host
    }
}
