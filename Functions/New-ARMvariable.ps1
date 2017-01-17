function New-ARMvariable
{
[cmdletbinding()]
Param(
    [Parameter(Mandatory)]
    [string]$Name
    ,
    [Parameter(ParameterSetName='Simple')]
    [string]$Value
    ,
    [Parameter(ParameterSetName='Complex')]
    [hashtable]$HashValues
)
    
    if ($PSCmdlet.ParameterSetName -eq "Simple")
    {        
        $propHash = [ordered]@{
            $Name = $Value
        }
    }

    if ($PSCmdlet.ParameterSetName -eq "Complex")
    {        
        $propHash = [ordered]@{
            $Name = $HashValues
        }
    }

    $propHash

}