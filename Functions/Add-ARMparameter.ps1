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
    [switch]$PassThru
)

Begin
{
    $f = $MyInvocation.InvocationName    
    Write-Verbose -Message "$f - START"
}

Process
{
    Write-Verbose -Message "$f -  Processing"
    
    if ($script:Template)
    {
        Write-Verbose -Message "$f -  Got template"
        foreach ($prop in $InputObject.psobject.Properties)
        {
            $value = $prop.Value
            Write-Verbose -Message "$f -  Processing property $($prop.Name)"            
            $script:Template.parameters | Add-Member -MemberType NoteProperty -Name $prop.Name -Value $value
        }
        <#
        foreach ($key in $InputObject.Keys)
        {
            $value = $InputObject.$key
            $customObject = [pscustomobject]$value
            $script:Template.parameters | Add-Member -MemberType NoteProperty -Name $key -Value $customObject

            if ($Template)
            {
                $Template.parameters | Add-Member -MemberType NoteProperty -Name $key -Value $customObject
            }
        }
        #>
        #$script:Template.parameters += $InputObject        
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
}