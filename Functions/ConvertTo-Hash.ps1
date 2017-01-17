function ConvertTo-Hash
{
[cmdletbinding()]
Param(
    [Parameter(ValueFromPipeline)]
    [PSCustomObject]$InputObject
)
Begin{
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"
}
Process
{   
    Write-Verbose -Message "$F -  processing $($inputobject.GetType().Name)" 
    if ($InputObject -is [array])
    {
        Write-Verbose -Message "Is array object"
        foreach ($item in $value)
        {            
            $item | ConvertTo-Hash
        }        
    }

    if ($InputObject -is [hashtable] -or $InputObject -is [System.Collections.Specialized.OrderedDictionary])
    {
        return $InputObject
    }

    $hash = [ordered]@{}

    if ($InputObject -is [System.Management.Automation.PSCustomObject])
    {
        Write-Verbose -Message "$f -  Processing [pscustomobject]"

        foreach ($prop in $InputObject.psobject.Properties)
        {
            $name = $prop.Name
            $value = $prop.Value
            Write-Verbose -Message "$f - Property [$name]"
            

            if ($value -is [System.Management.Automation.PSCustomObject])
            {
                Write-Verbose -Message "$f -  Value is PScustomobject"
                $value = $value | ConvertTo-Hash                    
            }

            if ($value -is [array])
            {
                Write-Verbose -Message "Is array value"
                $hashValue = @()
                if ($value[0] -is [hashtable] -or $value[0] -is [System.Collections.Specialized.OrderedDictionary] -or $value[0] -is [PSCustomObject])
                {
                    foreach ($item in $value)
                    {            
                        $hashValue += ($item | ConvertTo-Hash)
                    }
                }
                else 
                {
                    $hashValue = $value
                }                               
                $value = $hashValue
            }
            $hash.Add($name,$value)
        }
    }
    $hash
}
}