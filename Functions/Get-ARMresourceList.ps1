function Get-ARMresourceList
{
[cmdletbinding()]
Param(
    [string]$ResourceFile = (Split-Path -Path $PSScriptRoot -Parent | Join-Path -childpath Data | join-path -childpath allResources.json)
)
    $jsonContent = Get-Content -Path $ResourceFile -Encoding UTF8

    $allResources = $jsonContent | ConvertFrom-Json
    #$list = New-Object -TypeName System.Collections.Generic.LinkedList[string]
    $list = New-Object -TypeName System.Collections.Generic.List[string]

    foreach ($Resource in $allResources)
    {
        $providerNameSpace = $Resource.ProviderNamespace
        foreach ($type in $Resource.ResourceTypes)
        {            
            $fullNameSpace = "$providerNameSpace/$($type.ResourceTypeName)"            
            $list.Add($fullNameSpace)
        }
    }
    $list
}