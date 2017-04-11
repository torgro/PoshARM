#Requires -Version 5.0
function Get-ArmResourceList {
    <#
.SYNOPSIS
    Get a list of resource providers in Azure

.DESCRIPTION
     Get a list of resource providers in Azure. The list is read from an cached file in the module (.\Data\allResources.json)
     See also Update-ARMresourceList cmdlet.

.PARAMETER ResourceFile
    The path to a file that have the definition of the resource providers. 

.EXAMPLE
    Get-ARMresourceList

.EXAMPLE
    Get-ARMresourceList -ResourceFile c:\temp\allResources.json

.INPUTS
    PSCustomObject

.OUTPUTS
    string

.NOTES
    Author:  Tore Groneng
    Website: www.firstpoint.no
    Twitter: @ToreGroneng
#>
    [cmdletbinding()]
    Param(
        [string]
        $ResourceFile
    )
    # Seems like using the 'PSScriptRoot' automatic variable in a parameter default value can cause some problems.
    # Safer to initialize the parameter this way if it's undefined.
    if ([string]::IsNullOrEmpty($ResourceFile)) {
        $ResourceFile = Split-Path -Path $PSScriptRoot -Parent | Join-Path -childpath Data | join-path -childpath allResources.json
    }

    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"

    Write-Verbose -Message "$f -  Reading content from [$ResourceFile]"

    $jsonContent = Get-Content -Path $ResourceFile -Encoding UTF8

    $allResources = $jsonContent | ConvertFrom-Json

    $list = New-Object -TypeName System.Collections.Generic.List[string]

    foreach ($Resource in $allResources) {
        $providerNameSpace = $Resource.ProviderNamespace
        foreach ($type in $Resource.ResourceTypes) {            
            $fullNameSpace = "$providerNameSpace/$($type.ResourceTypeName)"            
            $list.Add($fullNameSpace)
        }
    }

    $list

    Write-Verbose -Message "$f - END"
}