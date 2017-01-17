#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. "$here\$sut"

$modulePath = Split-Path $PSScriptRoot -Parent
$modulepath = Join-Path -Path $modulePath -ChildPath posharm.psd1
Import-Module $modulePath

Describe "Add-ARMvariable" {
    New-ArmTemplate
    $expected = @{
        Name = "Test"
        Value = "foo-bar"
    }

    $actual = New-ARMvariable @expected

    Context "Without pipeline" {
        Add-ARMvariable -InputObject $actual
        $template = Get-ARMTemplate

        It "Should add a variable to a template" {        
            $template.variables | should not be $null
        }

        It "Should have a property named [$($expected.Name)]" {
            $template.variables.($expected.Name) | should not be $null
        }
    }
    
    Context "With pipeline" {
        New-ArmTemplate

        $actual | Add-ARMvariable
        $template = Get-ARMTemplate

        It "Should add a variable to a template" {        
            $template.variables | should not be $null
        }

        It "Should have a property named [$($expected.Name)]" {
            $template.variables.($expected.Name) | should not be $null
        }
    }
}

Remove-Module -name posharm -ErrorAction SilentlyContinue