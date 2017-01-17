#Requires -Version 4.0
function Get-ARMvariable
{
<#
.SYNOPSIS
    Brief synopsis about the function.
 
.DESCRIPTION
    Detailed explanation of the purpose of this function.
 
.PARAMETER Param1
    The purpose of param1.

.PARAMETER Param2
    The purpose of param2.
 
.EXAMPLE
     Get-ARMvariable -Param1 'Value1', 'Value2'

.EXAMPLE
     'Value1', 'Value2' | Get-ARMvariable

.EXAMPLE
     Get-ARMvariable -Param1 'Value1', 'Value2' -Param2 'Value'
 
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
    param ()

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

    #ParameterSetName = "__AllParameterSets"
    
    $allVariables = $script:Template.variables.Keys

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

    BEGIN 
    {
        $f = $MyInvocation.InvocationName
        Write-Verbose -Message "$f - START"
    }

    PROCESS 
    {       
        $Name = $PSBoundParameters.Name

        if ([string]::IsNullOrWhiteSpace($Name))
        {
            $Name = "*"
        }
        
        if (-not $PSBoundParameters.ContainsKey("Template"))
        {
            $template = $script:Template
        }
       
        foreach ($key in $template.variables.keys)
        {
            if ($key -like $Name)
            {
                @{
                    $key = $template.variables.$key
                }
            }
        }
    }

    END 
    {
        Write-Verbose -Message "$f - START"
    }

}
