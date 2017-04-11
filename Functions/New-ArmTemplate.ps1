function New-ArmTemplate {
    [cmdletbinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    Param(
        $schema = "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#"
        ,
        [switch]$Passthru
    )
    $templateObject = [pscustomobject][ordered]@{
        '$schema' = $schema
        contentVersion = "1.0.0.0"
        parameters = [pscustomobject]@{}
        variables = [pscustomobject]@{}
        resources = @()
        outputs = [pscustomobject]@{}
    }

    if ($script:Template) {
        $script:Template = $templateObject
    }

    if ($Passthru.IsPresent) {
        $templateObject
    }

}