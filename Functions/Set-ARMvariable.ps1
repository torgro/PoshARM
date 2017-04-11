#Requires -Version 5.0
function Set-ArmVariable {
    <#
.SYNOPSIS
    Update an existing variable in the ARM template

.DESCRIPTION
    Update an existing variable in the ARM template

.PARAMETER Name
    The variable Name. This is a Mandatory parameter and is an dynamic parameter

.PARAMETER Value
    The new value for the variable. This is a Mandatory parameter

.EXAMPLE
    Set-ARMvariable -Name nicName -Value "MyNewNic"

    This will set the variable nicName to value "MyNewNic"
.INPUTS
    string

.OUTPUTS

.NOTES
    Author:  Tore Groneng
    Website: www.firstpoint.no
    Twitter: @ToreGroneng
#>

    [cmdletbinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    Param(    
        [Parameter(Mandatory)]
        $Value
    )

    DynamicParam {
        $Dictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        $NewDynParam = @{
            Name = "Name"            
            Mandatory = $true
            ValueFromPipelineByPropertyName = $true
            ValueFromPipeline = $false
            DPDictionary = $Dictionary            
        }
    
        $allVariables = $script:Template.variables.PSobject.Properties.Name

        if ($allVariables) {
            $null = $NewDynParam.Add("ValidateSet", $allVariables)
        }
        else {
            $null = $NewDynParam.Add("ValidateSet", @("-"))
        }

        New-DynamicParam @NewDynParam
        $Dictionary
    }

    Begin {
        $f = $MyInvocation.InvocationName
        Write-Verbose -Message "$f - START"    
    }

    Process {
        $Name = $PSBoundParameters.Name    

        $oldValue = Get-ARMVariable -Name $Name | Select-Object -ExpandProperty $Name
        Write-Verbose -Message "$f -  Updating variable [$Name] from '$oldValue' to '$Value"
    
        if ($script:Template) {
            $script:Template.variables.$name = $Value
        }
    }

    End {
        Write-Verbose -Message "$f - END"
    
    }
}