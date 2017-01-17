#Requires -Version 3.0
function Get-ARMtemplateTestScript {

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
     Get-ARMtemplateTestScript -Param1 'Value1', 'Value2'

.EXAMPLE
     'Value1', 'Value2' | Get-ARMtemplateTestScript

.EXAMPLE
     Get-ARMtemplateTestScript -Param1 'Value1', 'Value2' -Param2 'Value'
 
.INPUTS
    String
 
.OUTPUTS
    PSCustomObject
 
.NOTES
    Author:  Mike F Robbins
    Website: http://mikefrobbins.com
    Twitter: @mikefrobbins
#>
    [CmdletBinding()]
    [OutputType('PSCustomObject')]
    param (
        [Parameter(
            Mandatory, 
            ValueFromPipeline)]
        [string[]]$Param1,

        [ValidateNotNullOrEmpty()]
        [string]$Param2
    )

    BEGIN 
    {
        $f = .InvokationName
        Write-Verbose -Message "$f - START"
    }

    PROCESS 
    {       
        foreach ($Param in $Param1) 
        {
            
        }
    }

    END 
    {
        Write-Verbose -Message "$f - START"
    }

}
