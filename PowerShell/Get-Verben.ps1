function Get-Verben 
{
    [CmdletBinding()]
    param ()
    
    $VerbenPath = Join-Path $PSScriptRoot 'CSV/Verben.csv'
    Get-Content -Path $VerbenPath | ConvertFrom-Csv

}
