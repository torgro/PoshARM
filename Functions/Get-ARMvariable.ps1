#Requires -Version 5.0
function Get-ARMvariable
{
<#
.SYNOPSIS
    Get all variable or a specific one by name.
 
.DESCRIPTION
    Get all variable or a specific one by name.
 
.PARAMETER Name
    Name of the variable to get. This is a dynamic parameter.
 
.EXAMPLE
     Get-ARMvariable

     This will return all variables in the ARM template
.EXAMPLE
     Get-ARMvariable -Name nicName

     This will get the variable with name nicName

.INPUTS
    String
 
.OUTPUTS
    PSCustomObject
 
.NOTES
    Author:  Tore Groneng
    Website: www.firstpoint.no
    Twitter: @ToreGroneng
#>
[CmdletBinding()]
[OutputType('PSCustomObject')]
Param()

DynamicParam
{
    $Dictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

    $NewDynParam = @{
        Name = "Name"            
        Mandatory = $false
        ValueFromPipelineByPropertyName = $true
        ValueFromPipeline = $false
        DPDictionary = $Dictionary            
    }

    $allVariables = $script:Template.variables.PSobject.Properties.Name

    if ($allVariables)
    {
        $null = $NewDynParam.Add("ValidateSet",$allVariables)
    }
    else
    {
        $null = $NewDynParam.Add("ValidateSet",@("-"))
    }

    New-DynamicParam @NewDynParam
    $Dictionary
}

Begin 
{
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"
}

Process 
{       
    $Name = $PSBoundParameters.Name

    if (-not $PSBoundParameters.ContainsKey("Template"))
    {
        $Template = $script:Template
    }

    if ($Name)
    {
        Write-Verbose -Message "$f -  Finding parameter with name [$Name]"        
        $Template.variables | Select-Object -Property $Name
    }
    else 
    {
        Write-Verbose -Message "$f -  Returning all variables"            
        $Template.variables
    }
}

End 
{
    Write-Verbose -Message "$f - START"
}
}
