#Requires -Version 5.0
function Get-ArmTemplateScript {
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

    Begin {
        $f = $MyInvocation.InvocationName
        Write-Verbose -Message "$f - START"
        $stringBuilder = New-Object -TypeName System.Text.StringBuilder
    }

    Process {    
        if ($Template) {        
            $null = $stringBuilder.AppendLine('New-ARMtemplate')
            $null = $stringBuilder.AppendLine()

            Write-Verbose -Message "$f -  Processing variables"
            [string]$vars = $Template.variables | Get-ARMvariableScript
            $null = $stringBuilder.AppendLine($vars)

            Write-Verbose -Message "$f -  Processing parameters"
            [string]$params = $Template.parameters | Get-ARMparameterScript
            $null = $stringBuilder.AppendLine($params)

            Write-Verbose -Message "$f -  Processing resources"        
            foreach ($resource in $Template.resources) {
                [string]$res = $resource | Get-ARMresourceScript
                $null = $stringBuilder.AppendLine($res)
            }       
        }
    }

    End {
        Write-Verbose -Message "$f - END"
        $stringBuilder.ToString()
    }

}