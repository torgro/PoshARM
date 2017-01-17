#Requires -Version 5.0
function Add-ARMresource
{
<#
.SYNOPSIS
    Add an ARM resource to an ARM template.

.DESCRIPTION
    Add an ARM resource to an ARM template

.PARAMETER InputObject
    The PSCustomObject of type 'ARMresource' to be added to the ARM template. This parameter is mandatory.

.PARAMETER Template
    The ARM template of type 'ARMtemplate' the parameter should be added to. If not specified, it will add the parameter to the module-level template

.EXAMPLE
    $newParam = @{
        APIversion = '2016-03-30'
        Name = 'MyVM'
        Location = 'EAST-US'
        Tags = @{tag=1}
        Comments = 'hey'
        DependsOn = @("item1","item2")
        SKU = @{value="skuvalue"}
        Kind = 'storage'
        Properties = @{prop1=1}
    }

    New-ARMresource @newParam -Type Microsoft.Compute/virtualMachines | Add-ARMresource

    This will add the resource to the module level template

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
    [PSTypeName('ARMresource')]
    $InputObject
    ,    
    [PSTypeName('ARMtemplate')]
    $Template
    ,
    [switch]
    $PassThru
)

Begin
{
    $f = $MyInvocation.InvocationName    
    Write-Verbose -Message "$f - START"
}

Process
{
    if (-not $Template)
    {
        Write-Verbose -Message "$f -  Using module level template"
        $Template = $script:Template
    }

    if ($Template)
    {
        $Template.resources += $InputObject
    }

    if ($PassThru.IsPresent)
    {
        $InputObject
    }
}

End
{
    Write-Verbose -Message "$f - End"
}
}