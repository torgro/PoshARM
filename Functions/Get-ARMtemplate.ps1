#Requires -Version 5.0
function Get-ARMtemplate
{
<#
.SYNOPSIS
    Get the ARM template defined at the module level

.DESCRIPTION
    Get the ARM template defined at the module level

.PARAMETER AsJSON
    Returns the ARM template as a JSON string

.PARAMETER AsHashTableString
    Returns the ARM template as a Hashtable object

.EXAMPLE
    Get-ARMtemplate | Get-ARMtempateScript

.INPUTS
    PSCustomObject

.OUTPUTS
    string

.NOTES
    Author:  Tore Groneng
    Website: www.firstpoint.no
    Twitter: @ToreGroneng
#>
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

Begin
{
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"    
}

Process
{
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
   
}