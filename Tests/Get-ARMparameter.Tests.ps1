#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. "$here\$sut"
#Import-Module "C:\Users\tore\Dropbox\SourceTreeRepros\PoshARM\PoshARM.psd1"

$modulePath = Split-Path $PSScriptRoot -Parent
$modulepath = Join-Path -Path $modulePath -ChildPath posharm.psd1
Import-Module $modulePath

Describe "Get-ARMparameter" {
    New-ArmTemplate
    $expected1 = @{
        Name = "Param1"
        Type = "string"
    }

    $expected2 = @{
        Name = "Param2"
        Type = "int"
    }
    New-ARMparameter @expected1 | Add-ARMparameter
    New-ARMparameter @expected2 | Add-ARMparameter

    $actual1 = Get-ARMparameter -Name param1
    $actual2 = Get-ARMparameter -Name param2

    It "Should return all parameters if no name is provided" {
        ((Get-ARMparameter).PSobject.Properties | Measure-Object).Count | Should be 2
    }

    It "Parameter object 1 should not be `$null" {
        $actual1 | Should not be $null
    }

    It "Parameter object 1 should have a property named [$($expected1.Name)]" {
        $actual1.($expected1.Name) | Should not be $null
    }

    It "Parameter object 2 should not be `$null" {
        $actual2 | Should not be $null
    }

    It "Parameter object 2 should have a property named [$($expected2.Name)]" {
        $actual2.($expected2.Name) | Should not be $null
    }

    $name = $expected1.Name
    $actualObj = $actual1.$name    

    It "'$name' should have a property Type [$($expected1.type)]" {
        $actualObj.Type | Should be $expected1.Type
    }

    $name = $expected2.Name
    $actualObj = $actual2.$name    

    It "'$name' should have a property Type [$($expected2.type)]" {
        $actualObj.Type | Should be $expected2.Type
    }
}