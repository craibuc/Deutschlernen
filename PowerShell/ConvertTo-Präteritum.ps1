function ConvertTo-Präteritum
{
    [CmdletBinding()]
    param (
        # [Parameter(ValueFromPipeline)]
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Infinitiv,

        [switch]$OnlyIrregularForms
    )
    
    begin
    {
        $VerbenPräteritumPath = Join-Path $PSScriptRoot 'CSV/Verben.Präteritum.csv'
        $VerbenPräteritum = Get-Content -Path $VerbenPräteritumPath | ConvertFrom-Csv
    }
    
    process {
        
        foreach($I in $Infinitiv)
        {

            $VerbenPräteritum | Where-Object { $_.Infinitiv -eq $I } | ForEach-Object {

                # split seprable prefix from the root (ab.holen --> ab and holen)
                $_.Infinitiv -match "((?'prefix'\w*)\.)?(?'root'.*)" | Out-Null

                $Prefix = $matches['prefix']
                Write-Debug "Prefix: $Prefix"

                $Root = $($matches['root'])
                Write-Verbose "Root: $Root"

                # determine the verb's stem
                $Verbstamm = [string]::IsNullOrEmpty($_.Verbstamm) ? ($Root -replace 'en', '') : $_.Verbstamm
                Write-Verbose "Verbstamm: $Verbstamm"

                if ( [string]::IsNullOrEmpty($_.Verbstamm) -or $_.Type -eq 'schwache' ){

                    $_.Verbstamm = $Verbstamm

                    $_.'1s' = ("{0}te {1}" -f $Verbstamm, $Prefix).TrimEnd()
                    $_.'2s' = ("{0}test {1}" -f $Verbstamm, $Prefix).TrimEnd()
                    $_.'3s' = ("{0}te {1}" -f $Verbstamm, $Prefix).TrimEnd()
                    $_.'1p' = ("{0}ten {1}" -f $Verbstamm, $Prefix).TrimEnd()
                    $_.'2p' = ("{0}tet {1}" -f $Verbstamm, $Prefix).TrimEnd()
                    $_.'3p' = ("{0}ten {1}" -f $Verbstamm, $Prefix).TrimEnd()

                }
                else {

                    $_.'1s' = ("{0}{1} {2}" -f $Verbstamm, $_.'1s', $Prefix).TrimEnd()
                    $_.'2s' = ("{0}{1} {2}" -f $Verbstamm, $_.'2s', $Prefix).TrimEnd()
                    $_.'3s' = ("{0}{1} {2}" -f $Verbstamm, $_.'3s', $Prefix).TrimEnd()
                    $_.'1p' = ("{0}{1} {2}" -f $Verbstamm, $_.'1p', $Prefix).TrimEnd()
                    $_.'2p' = ("{0}{1} {2}" -f $Verbstamm, $_.'2p', $Prefix).TrimEnd()
                    $_.'3p' = ("{0}{1} {2}" -f $Verbstamm, $_.'3p', $Prefix).TrimEnd()

                }

                $_

            }

        }
    }

    end {}

}