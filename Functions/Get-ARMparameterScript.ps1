#Requires -Version 5.0
function Get-ARMparameterScript
{
<#
.SYNOPSIS
    Get the Powershell script that will recreate the parameteres in the ARM template

.DESCRIPTION
    Get the Powershell script that will recreate the parameteres in the ARM template. This cmdlet is invoked by the Get-ARMtemplateScript cmdlet.

.PARAMETER Parameters
    The parameters property of the ARM template

.EXAMPLE
    Get-ARMtemplate | Select-Object parameters | Get-ARMparameterScript

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
    $Parameters
)

Begin
{
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"    
}

Process
{    
    Write-Verbose -Message "$f -  Converting to hashtable"
    
    $allParams = $Parameters | ConvertTo-Hash

    foreach ($key in $allParams.Keys)
    {
        Write-Verbose -Message "$f -  Processing key [$key]"
        
        $cmdline = '$parameter = '
        $paramHash =  @{
            Name = $key
        }

        foreach ($subkey in $allParams.$key.Keys)
        {
            $paramHash.Add($subkey,$allParams.$key.$subkey)
        }
        
        $params = $paramHash | Out-HashString
            
        $cmdline = "$cmdline $params" + [environment]::NewLine
        "$cmdline" + "New-ARMparameter @parameter | Add-ARMparameter" + [environment]::NewLine + [environment]::NewLine
    }
}

End
{
    Write-Verbose -Message "$f - END"
    
}
}