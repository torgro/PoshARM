#Requires -Version 5.0
function New-ARMvariable
{
<#    
.SYNOPSIS    
    Create a new ARM template variable

.DESCRIPTION
    Create a new ARM template variable

.PARAMETER Name
    The name of the variable. This is Mandatory

.PARAMETER Value
    The variable value. This is Mandatory

.EXAMPLE
    New-ARMvariable -Name nicName -Value "myNIC"

    This will create a new variable named nicName of with vavlue "myNIC"

.EXAMPLE
    $name = "subnet"
    $expectedHash = @{
        Name = "NameKey"
        Ipaddress = "10.0.0.2"
        SubNet = "255.255.255.0"
    }
    $expectedHash | New-ARMvariable -Name $name

    This will create a new variable named subnet which have 3 properties: Name, IpAddress and SubNet

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
    [string]
    $Name
    ,
    [Parameter(ParameterSetName='Simple')]
    [string]
    $Value
    ,
    [Parameter(
        ValueFromPipeline,
        ParameterSetName='Complex'
    )]
    [hashtable]
    $HashValues
)
Begin
{
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"        
}

Process
{
    if ($PSCmdlet.ParameterSetName -eq "Simple")
    {        
        $propHash = [PSCustomObject][ordered]@{
            PSTypeName = "ARMvariable"
            $Name = $Value
        }
    }

    if ($PSCmdlet.ParameterSetName -eq "Complex")
    {        
        $propHash = [PSCustomObject][ordered]@{
            PSTypeName = "ARMvariable"
            $Name = [PSCustomObject]$HashValues
        }
    }
    $propHash
}

End
{
    Write-Verbose -Message "$f - END"
}

}