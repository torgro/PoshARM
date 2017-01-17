function Get-ARMresourceScript
{
[cmdletbinding()]
Param(
    [Parameter(ValueFromPipeline)]
    $Resources
)
Begin
{
    #$allResources = New-Object -TypeName System.Collections.Generic.List[object]
    $cmd = Get-Command -Name New-ARMresource

    $cmdParams = $cmd.Parameters.Keys
}

Process
{
    foreach ($resource in $Resources)
    {
        $hash = $resource | ConvertTo-Hash
        $cmdline = '$resource = '

        foreach ($key in $hash.Keys)
        {
            if ($key -notin $cmdParams)
            {
                Write-Warning -Message "Parameter [$key] not found in $($cmd.Name)"
            }
        }

        $params = $hash | Out-HashString
        $cmdline = "$cmdline$params" + [environment]::NewLine
        "$cmdline" + "New-ARMresource @resource | Add-ARMresource" + [environment]::NewLine + [environment]::NewLine
    }
}
}