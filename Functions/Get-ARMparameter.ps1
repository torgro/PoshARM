#Requires -Version 5.0
function Get-ArmParameter {
    <#
.SYNOPSIS
    Get all parameters or a specific one by name.
 
.DESCRIPTION
    Get all parameters or a specific one by name.
 
.PARAMETER Name
    Name of the parameter to get. This is a dynamic parameter.
 
.EXAMPLE
     Get-ARMparameter

     This will return all parameters in the ARM template
.EXAMPLE
     Get-ARMparameter -Name adminUsername

     This will get the parameter with name adminUsername

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
    Param ()

    DynamicParam {
        $Dictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        $NewDynParam = @{
            Name = "Name"            
            Mandatory = $false
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

    BEGIN {
        $f = $MyInvocation.InvocationName
        Write-Verbose -Message "$f - START"
    }

    PROCESS {       
        $Name = $PSBoundParameters.Name
    
        if (-not $PSBoundParameters.ContainsKey("Template")) {
            $Template = $script:Template
        }

        if ($Name) {
            Write-Verbose -Message "$f -  Finding parameter with name [$Name]"
        
            $Template.parameters | Select-Object -Property $Name
        }
        else {
            Write-Verbose -Message "$f -  Returning all parameters"            
            $Template.parameters
        }
    }

    END {
        Write-Verbose -Message "$f - START"
    }
}
