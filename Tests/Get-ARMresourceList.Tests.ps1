#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. "$here\$sut"

$modulePath = Split-Path $PSScriptRoot -Parent
$modulepath = Join-Path -Path $modulePath -ChildPath posharm.psd1
Import-Module $modulePath

Describe "Get-ARMresourceList" {
    $resourceList = Get-ARMresourceList
    
    It "Should return something" {
        $resourceList | Should not be $null
    }

    It "Should return an array" {
        $resourceList -is [array] | should be $true
    }

    It "The array should contains strings" {
        $resourceList[0].GetType().Name | Should be "String"
    }

    Context "Loading list from resourceFile" {
        #FIXME add tests here
    }
}

Remove-Module -name posharm -ErrorAction SilentlyContinue