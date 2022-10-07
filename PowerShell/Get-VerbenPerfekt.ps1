function Get-VerbenPerfekt
{
    [CmdletBinding()]
    param ()
    
    $Path = Join-Path $PSScriptRoot 'CSV/Verben.Perfekt.csv'
    Get-Content -Path $Path | ConvertFrom-Csv

}
