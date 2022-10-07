function Get-Präfix
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]$Trennbaren,
        [Parameter()]
        [switch]$Untrennbaren
    )

    $PräfixenPath = Join-Path $PSScriptRoot 'CSV/Präfixen.csv'
    Get-Content -Path $PräfixenPath | ConvertFrom-Csv | ForEach-Object { 
        $_.Trennbaren = [boolean]$_.Trennbaren
        $_.Untrennbaren = [boolean]$_.Untrennbaren
        $_
    } | Where-Object { -not(($Trennbaren.IsPresent -and -not $_.Trennbaren) -or ($Untrennbaren.IsPresent -and -not $_.Untrennbaren)) }

}