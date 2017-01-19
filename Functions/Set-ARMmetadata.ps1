function Set-ARMmetadata
{
<#
.SYNOPSIS
    Creates a metadata.json file for your ARM template

.DESCRIPTION
    Creates a metadata.json file for your ARM template

.EXAMPLE
    $meta = @{
        ItemDisplayName = "Blank Template"
        Description     = "A blank template and empty parameters file"
        Summary         = "A blank template and empty parameters file.  "
        GitHubUsername  = "torgro"
    }
    Set-ARMmetadata @meta

    This will create a file metadata.json containing the information in $meta

.INPUTS
    string

.OUTPUTS
    
.NOTES
    Author:  Tore Groneng
    Website: www.firstpoint.no
    Twitter: @ToreGroneng
#>
[cmdletbinding()]
Param(
    $ItemDisplayName
    ,
    $Description
    ,
    $Summary
    ,
    $GitHubUsername
    ,
    $FileName = "metadata.json"
)
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"

    $resolvedFilename = Resolve-Path -Path $FileName -ErrorAction SilentlyContinue
    
    if (-not $resolvedFilename)
    {
        $resolvedFilename = Join-Path -Path $PSScriptRoot -ChildPath metadata.json
    }

    $output = [pscustomobject]@{
        itemDisplayName = $ItemDisplayName
        description = $Description
        summary = $Summary
        githubUsername = $GitHubUsername
        dateUpdated = (Get-Date).ToString("yyyy-MM-dd")
    }

    $json = $output | ConvertTo-Json
    Write-Verbose -Message "$f -  json output $json"
    Write-Verbose -Message "$f -  Writing to file [$resolvedFilename]"
    
    Set-Content -Path $resolvedFilename -Value $json -Encoding UTF8
    
    Write-Verbose -Message "$f - END"
}