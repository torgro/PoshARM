#Requires -Version 5.0
function Set-ARMparameter {
    <#
.SYNOPSIS
    Update an existing parameter in the ARM template

.DESCRIPTION
    Update an existing parameter in the ARM template

.PARAMETER Name
    The variable Name. This is a Mandatory parameter and is an dynamic parameter

.PARAMETER Value
    The new value for the variable. This is a Mandatory parameter

.EXAMPLE
    Set-ARMparameter -Name adminUsername -Value [PSCustomObject]@{type="string"}

    This will update the parameter adminUsername with a type of string
.EXAMPLE
    $newParameter = New-ARMparameter -Name adminUsername -Type string -DefaultValue "foo"
    $newParameter | Add-ARMparameter
    $newParameter.adminUsername.defaultValue = "new foo"

    Set-ARMparameter -Name adminUsername -Value $newParameter

    This will create a new parameter adminUsername and add it to the ARM template. The defaultValue
    is updated to "new foo" and the value of the adminUsername parameter is updated.

.INPUTS
    PSCustomObject

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
        [PSCustomObject]
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
    
        $allParameters = $script:Template.parameters.PSobject.Properties.Name

        if ($allParameters) {
            $null = $NewDynParam.Add("ValidateSet", $allParameters)
        }
        else {
            $null = $NewDynParam.Add("ValidateSet", @("-"))
        }

        New-DynamicParam @NewDynParam
        $Dictionary
    }
    # FIXME this cmdlet should reflect the parameters of New-ARMparameter
    Begin {
        $f = $MyInvocation.InvocationName
        Write-Verbose -Message "$f - START"    
    }

    Process {
        $Name = $PSBoundParameters.Name

        $oldvalue = ((Get-ARMparameter -Name $Name | Select-Object -ExpandProperty $name | ConvertTo-Hash | Out-HashString) -replace [environment]::NewLine, "") -replace "  ", ""
        $newValue = (($value | ConvertTo-Hash | Out-HashString) -replace [environment]::NewLine, "") -replace "  ", ""
        Write-Verbose -Message "$f -  Updating variable [$Name] from '$oldValue' to '$newValue"

        if ($script:Template) {
            $script:Template.parameters.$name = $Value
        }
    }

}