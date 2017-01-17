#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. "$here\$sut"
#Import-Module "C:\Users\tore\Dropbox\SourceTreeRepros\PoshARM\PoshARM.psd1"

$modulePath = Split-Path $PSScriptRoot -Parent
$modulepath = Join-Path -Path $modulePath -ChildPath posharm.psd1
Import-Module $modulePath

Describe "Get-ARMvariable" {
    New-ArmTemplate
    $expected1 = @{
        Name = "Var1"
        value = "Foo-bar1"
    }

    $expected2 = @{
        Name = "Var2"
        Value = "FooBar2"
    }
    New-ARMvariable @expected1 | Add-ARMvariable
    New-ARMvariable  @expected2 | Add-ARMvariable

    $actual1 = Get-ARMvariable -Name Var1
    $actual2 = Get-ARMvariable -Name Var2

    It "Should return all variables if no name is provided" {
        ((Get-ARMvariable).PSobject.Properties | Measure-Object).Count | Should be 2
    }

    It "Variable object 1 should not be `$null" {
        $actual1 | Should not be $null
    }

    It "Variable object 1 should have a property named [$($expected1.Name)]" {
        $actual1.($expected1.Name) | Should not be $null
    }

    It "Variable object 2 should not be `$null" {
        $actual2 | Should not be $null
    }

    It "Variable object 2 should have a property named [$($expected2.Name)]" {
        $actual2.($expected2.Name) | Should not be $null
    }

    $name = $expected1.Name
    $actualValue = $actual1.$name    

    It "'$name' should have a property value of [$($expected1.value)]" {
        $actualValue | Should be $expected1.value
    }

    $name = $expected2.Name
    $actualValue = $actual2.$name   

    It "'$name' should have a property value of [$($expected2.value)]" {
        $actualValue | Should be $expected2.Value
    }
}