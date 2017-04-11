[cmdletbinding()]
Param(
    [Parameter(Mandatory)]
    [string]
    $APIkey
)

Publish-Module -NuGetApiKey $APIkey -Name .\posharm.psd1