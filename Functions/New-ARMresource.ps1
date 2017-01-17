#Requires -Version 5.0
function New-ARMresource
{
<#    
.SYNOPSIS    
    Create a new ARM template resource

.DESCRIPTION
    Create a new ARM template resource

.PARAMETER Name
    The name of the parameter. This is Mandatory

.PARAMETER Type
    The parameter type. These are the types returned by Get-ARMresourceList

.EXAMPLE
    $newRes = @{
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

    New-ARMresource @newRes -Type Microsoft.Compute/virtualMachines

.INPUTS
    String

.OUTPUTS
    PSCustomObject

.NOTES
    Author:  Tore Groneng
    Website: www.firstpoint.no
    Twitter: @ToreGroneng
#>
[cmdletbinding()]
Param(
    [string]
    $APIversion
    ,
    [string]
    $Name
    ,
    [string]
    $Location
    ,
    [hashtable]
    $Tags
    ,
    [string]
    $Comments
    ,
    [string[]]
    $DependsOn
    ,
    [hashtable]
    $SKU
    ,
    [string]
    $Kind
    ,
    [hashtable]
    $Properties
    ,
    [hashtable]
    $Resources
)
DynamicParam
{
    $Dictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

    $NewDynParam = @{
        Name = "Type"
        Alias = "ResourceName"
        Mandatory = $true
        ValueFromPipelineByPropertyName = $true
        ValueFromPipeline = $true
        DPDictionary = $Dictionary
    }

    $all = Get-ARMresourceList -ErrorAction SilentlyContinue
    
    if ($all)
    {
        $null = $NewDynParam.Add("ValidateSet",$all)
    }

    New-DynamicParam @NewDynParam
    $Dictionary
}

Begin
{
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"
}

Process
{
    $ResourceName = $PSBoundParameters.Type

    $propHash = [ordered]@{
        PSTypeName = "ARMresource"
        apiVersion = $APIversion
        type = $ResourceName
    }

    if ($Name)
    {
        $propHash["name"] = $Name
    }

    if ($Location)
    {
        $propHash.location = $Location
    }

    if ($DependsOn)
    {        
        $propHash.dependsOn = $DependsOn
    }

    if ($Properties)
    {        
        $propHash.properties = $Properties
    }

    if ($Tags)
    {
        $propHash.tags = $Tags
    }

    if ($Comments)
    {
        $propHash.comments = $Comments
    }       
    
    if ($Resources)
    {        
        $propHash.resources = $Resources
    }

    if ($SKU)
    {        
        $propHash.SKU = $SKU
    }

    if ($Kind)
    {        
        $propHash.kind = $Kind
    }

    [PSCustomObject]$propHash
}
}