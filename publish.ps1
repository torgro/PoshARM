[cmdletbinding()]
Param(
    [Parameter(Mandatory)]
    [string]
    $APIkey
)

$tags = @(
    "Azure template"
    , 
    "ARM template"
    , 
    "ARM"
    , 
    "JSON"
    , 
    "script ARM template"
    ,
    "Powershell ARM"
    ,
    "Azure Resource Manager"
)


Publish-Module -NuGetApiKey $APIkey -Name .\CliMenu.psd1