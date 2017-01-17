function Set-ARMmetadata
{
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