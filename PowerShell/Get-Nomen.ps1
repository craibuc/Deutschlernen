function Get-Nomen
{
    [CmdletBinding()]
    param ()
    
    $VerbenPath = Join-Path $PSScriptRoot 'CSV/Nomen.csv'
    Get-Content -Path $VerbenPath | ConvertFrom-Csv

}
