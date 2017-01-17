#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. "$here\$sut"

$modulePath = Split-Path $PSScriptRoot -Parent
$modulepath = Join-Path -Path $modulePath -ChildPath posharm.psd1
Import-Module $modulePath

Describe "Import-ARMtemplate" {
    $modulepath = Split-Path $PSScriptRoot -Parent
    $testfilePath = Join-Path -Path $modulepath -ChildPath "TestFiles\simplevm.json"
    
    $jsonString = Get-Content -Path $testfilePath -Encoding UTF8 -Raw

    It "JSON string should not be null" {
        $jsonString | Should not be $null
    }

    It "TestFilePath should exists" {
        Test-Path -Path $testfilePath | Should be $true
    }

    Context "After module loaded" {
        It "Should not have an ARM template after module Import" {
            ((Get-ARMtemplate).PSobject.Properties | Measure-Object).Count | should be 0
        }
    }
    
    Context "Importing template from file" {

        Import-ARMtemplate -FileName $testfilePath

        It "Should import a template" {
            ((Get-ARMtemplate).PSobject.Properties | Measure-Object).Count | Should BeGreaterThan 0
        }
    }

    Remove-Module PoshARM
    Import-Module $modulePath

    Context "Importing template from file with pipeline" {

        Get-ChildItem -path $testfilePath | Import-ARMtemplate

        It "Should import a template" {
            ((Get-ARMtemplate).PSobject.Properties | Measure-Object).Count | Should BeGreaterThan 0
        }
    }

    Remove-Module PoshARM
    Import-Module $modulePath

    Context "Importing template from a string variable" {

        Import-ARMtemplate -JsonString $jsonString

        It "Should import a template" {
            ((Get-ARMtemplate).PSobject.Properties | Measure-Object).Count | Should BeGreaterThan 0
        }
    }

    Remove-Module PoshARM
    Import-Module $modulePath

    Context "Importing template from a string variable with pipeline" {

        $jsonString | Import-ARMtemplate

        It "Should import a template" {
            ((Get-ARMtemplate).PSobject.Properties | Measure-Object).Count | Should BeGreaterThan 0
        }
    }

    Remove-Module PoshARM
    Import-Module $modulePath

    Context "Importing template from clipboard" {
        $jsonString | Set-Clipboard
        Get-Clipboard | Import-ARMtemplate

        It "Should import a template" {
            ((Get-ARMtemplate).PSobject.Properties | Measure-Object).Count | Should BeGreaterThan 0
        }
    }
    
}

Remove-Module -name posharm -ErrorAction SilentlyContinue