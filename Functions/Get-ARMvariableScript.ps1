#Requires -Version 5.0
function Get-ARMvariableScript
{
<#
.SYNOPSIS
    Get the Powershell script that will recreate the variables in the ARM template

.DESCRIPTION
    Get the Powershell script that will recreate the variables in the ARM template. This cmdlet is invoked by the Get-ARMtemplateScript cmdlet.

.PARAMETER Variables
    The variables propterty of the ARM template

.EXAMPLE
    Get-ARMtemplate | Select-Object Variables | Get-ARMvariableScript

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
    [PSCustomObject]
    $Variables
)

Begin
{
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"    
}

Process
{    
    #if ($Variables.variables)
    if ($Variables)
    {
        $allVars = $Variables | ConvertTo-Hash

        foreach ($key in $allVars.Keys)
        {
            Write-Verbose -Message "$f -  Processing key [$key]"

            $cmdLine = "New-ARMvariable -Name $key -Value " + '"' + $($allVars.$key) + '" | Add-ARMVariable'
            $cmdLine += [environment]::NewLine
        }
    }    
}

End 
{
    $cmdLine
    Write-Verbose -Message "$f - END"
}

}
