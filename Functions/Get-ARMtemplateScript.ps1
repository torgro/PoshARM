#Requires -Version 5.0
function Get-ARMtemplateScript
{
<#
.SYNOPSIS
    Get the Powershell script that will recreate the ARM template

.DESCRIPTION
    Get the Powershell script that will recreate the ARM template

.PARAMETER Template
    An PScustomObject that is an ARM template

.EXAMPLE
    Get-ARMtemplate | Get-ARMtemplateScript

.INPUTS
    PSCustomObject

.OUTPUTS
    string

.NOTES
    Author:  Tore Groneng
    Website: www.firstpoint.no
    Twitter: @ToreGroneng
#>
    
[cmdletbinding()]
Param(
    [Parameter(ValueFromPipeline)]
    [pscustomobject]$Template
)

Begin
{
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"
}

Process
{    
    if ($Template)
    {        
        'New-ARMtemplate'
        ''

        $Template.variables | Get-ARMvariableScript
        $Template.parameters | Get-ARMparameterScript

        foreach ($resource in $Template.resources)
        {
            $resource | Get-ARMresourceScript
        }       
    }
}

}