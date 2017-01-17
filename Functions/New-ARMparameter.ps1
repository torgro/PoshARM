#Requires -Version 5.0
function New-ARMparameter
{
    <#    
    .SYNOPSIS    
        Create a new ARM template parameter
    
    .DESCRIPTION
        Create a new ARM template parameter
    
    .PARAMETER Name
        The name of the parameter. This is Mandatory

    .PARAMETER Type
        The parameter type. Allowed values are "string","secureString","int","bool","object","secureObject","array"

    .EXAMPLE
         New-ARMparameter -Name adminUsername -Type String
    
         This will create a new parameter named adminUsername of type String

    .EXAMPLE
         $AllowedValues = @{
             AllowedValues = "2008-R2-SP1","2012-Datacenter","2012-R2-Datacenter","2016-Nano-Server","2016-Datacenter-with-Containers","2016-Datacenter"
         }
         New-ARMparameter -Name windowsOSVersion -Type String -DefaultValue "2016-Datacenter" @allowedValues
    
         This will create a new parameter named windowsOSVersion of type String, with a default value of "2016-Datacenter" which
         is in the allowedValues list/array         
    
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
    [Parameter(Mandatory)]
    $Name
    ,
    [Parameter(Mandatory)]
    [ValidateSet("string","secureString","int","bool","object","secureObject","array")]
    $Type
    ,
    $DefaultValue
    ,
    $AllowedValues
    ,
    $MinValue
    ,
    $MaxValue
    ,
    $MinLength
    ,
    $MaxLength
    ,
    $Description
    ,
    $Metadata
)

    $propHash = [PSCustomobject][ordered]@{        
        type = $Type
    }

    if ($DefaultValue)
    {
        $null = $propHash.defaultValue = $DefaultValue
    }

    if ($AllowedValues)
    {
        $null = $propHash.allowedValues = $AllowedValues
    }

    if ($MinValue)
    {
        $null = $propHash.minValue = $MinValue
    }

    if ($MaxValue)
    {
        $null = $propHash.maxValue = $MaxValue
    }

    if ($MinLength)
    {
        $null = $propHash.minLength = $MinLength
    }

    if ($MaxLength)
    {
        $null = $propHash.maxLength = $MaxLength
    }

    if ($Description)
    {
        Write-Verbose -Message "Adding description"
        $null = $propHash.metadata = @{description = $Description}
    }

    if ($Metadata)
    {
        $null = $propHash.metadata += $Metadata
    }

    $out = [PSCustomobject]@{
        PSTypeName = "ARMparameter"
        $Name = $propHash    
    }

    $out

}