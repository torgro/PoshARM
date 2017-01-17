function New-ARMresource
{
[cmdletbinding()]
Param(
    [string]$APIversion
    ,
    [string]$Name
    ,
    [string]$Location
    ,
    [hashtable]$Tags
    ,
    [string]$Comments
    ,
    [string[]]$DependsOn
    ,
    [hashtable]$SKU
    ,
    [string]$Kind
    ,
    [hashtable]$Properties
    ,
    [hashtable]$Resources
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
        #$all = @("hei","tore")
        if ($all)
        {
            $null = $NewDynParam.Add("ValidateSet",$all)
        }

        New-DynamicParam @NewDynParam
        $Dictionary
    }
Begin
{

}

Process
{
    $ResourceName = $PSBoundParameters.Type

    $propHash = [ordered]@{
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

    $out = @{
        resources = $propHash    
    }

    $propHash
}
}