#Requires -Version 5.0
function Add-ArmVariable {
    <#
.SYNOPSIS
    Add an ARM variable to an ARM template.

.DESCRIPTION
    Add an ARM variable to an ARM template

.PARAMETER InputObject
    The PSCustomObject of type 'ARMvariable' to be added to the ARM template. 

.PARAMETER Template
    The ARM template of type 'ARMtemplate' the variable should be added to. If not specified, it will add the variable to the module-level template

.EXAMPLE
    $nicName = New-ARMvariable -Name nicName -Value "myNIC"
    Add-ARMvariable -InputObject $nicName

    This will add the variable nicName to the module level template

.EXAMPLE
    New-ARMvariable -Name nicName -Value "myNIC" | Add-ARMvariable -Template $myTemplate

    This will add the variable nicName to the userdefined template $myTemplate

.INPUTS
    PSCustomObject

.OUTPUTS
    PSCustomObject

.NOTES
    Author:  Tore Groneng
    Website: www.firstpoint.no
    Twitter: @ToreGroneng
#>
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [PSTypeName('ARMvariable')]
        $InputObject
        ,
        [PSTypeName('ARMtemplate')]
        $Template
        ,
        [switch]
        $PassThru
    )
    Begin {
        $f = $MyInvocation.InvocationName    
        Write-Verbose -Message "$f - START"
    }

    Process {
        Write-Verbose -Message "$f -  Processing"

        if (-not $Template) {
            Write-Verbose -Message "$f -  Using module level template"
            $Template = $script:Template
        }
    
        if ($Template) {
            Write-Verbose -Message "$f -  Have a template"
            foreach ($prop in $InputObject.PSobject.Properties) {
                $value = $prop.Value
                Write-Verbose -Message "$f -  Processing property $($prop.Name)"            
                $Template.variables | Add-Member -MemberType NoteProperty -Name $prop.Name -Value $value
            } 
        }

        if ($PassThru.IsPresent) {
            $InputObject
        }
    }

    End {
        Write-Verbose -Message "$f - End"
    }

}