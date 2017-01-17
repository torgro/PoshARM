#Requires -Version 5.0
function Add-ARMparameter
{
<#
.SYNOPSIS
    Add an ARM parameter to an ARM template.

.DESCRIPTION
    Add an ARM parameter to an ARM template

.PARAMETER InputObject
    The PSCustomObject of type 'ARMparameter' to be added to the ARM template. 

.PARAMETER Template
    The ARM template of type 'ARMtemplate' the parameter should be added to. If not specified, it will add the parameter to the module-level template

.EXAMPLE
    $adminUser = New-ARMparameter -Name adminUsername -Type String
    Add-ARMparameter -InputObject $adminUser

    This will add the parameter adminUsername to the module level template

.EXAMPLE
    New-ARMparameter -Name adminUsername -Type String |  Add-ARMparameter -Template $myTemplate

    This will add the parameter adminUsername to the userdefined template $myTemplate

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
    [PSTypeName('ARMparameter')]
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
    Write-Verbose -Message "$f -  Processing"

    if (-not $Template)
    {
        Write-Verbose -Message "$f -  Using module level template"
        $Template = $script:Template
    }
    
    if ($Template)
    {
        Write-Verbose -Message "$f -  Have a template"
        foreach ($prop in $InputObject.PSobject.Properties)
        {
            $value = $prop.Value
            Write-Verbose -Message "$f -  Processing property $($prop.Name)"            
            $Template.parameters | Add-Member -MemberType NoteProperty -Name $prop.Name -Value $value
        }    
    }
    else 
    {
        Write-Verbose -Message "$f -  Template not found"        
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