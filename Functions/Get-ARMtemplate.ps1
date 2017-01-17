function Get-ARMtemplate
{
[cmdletbinding(
    DefaultParameterSetName='foo'
)]
Param(
    [Parameter(ParameterSetName='JSON')]
    [switch]$AsJSON
    ,
    [Parameter(ParameterSetName='HASH')]
    [switch]$AsHashTableString
)
    Write-Verbose -Message "PSScriptRoot = $PSScriptRoot"
    Write-Verbose -Message "Location = $((Get-Location).Path)"
    if ($AsJSON.IsPresent -eq $false -and $AsHashTableString.IsPresent -eq $false)
    {
        $Script:Template
    }

    if ($AsJSON.IsPresent)
    {
        $json = $Script:Template | ConvertTo-Json -Depth 99
        $json = $json.replace("\u0027","'")#'
        $json
    }

    if ($AsHashTableString.IsPresent)
    {
        $Script:Template | ConvertTo-Hash | Out-HashString
    }    
}