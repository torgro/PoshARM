[cmdletbinding()]
Param(
    [Parameter(Mandatory)]
    [string]
    $APIkey
)

$tags = @(
    "Azure"
    , 
    "Template"
    , 
    "ARM"
    , 
    "JSON"
    , 
    "Resource"
    ,
    "Manager"
    ,
    "Convert"
    ,
    "Import"
)


Publish-Module -NuGetApiKey $APIkey -Name .\posharm.psd1