#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. "$here\$sut"

$modulePath = Split-Path $PSScriptRoot -Parent
$modulepath = Join-Path -Path $modulePath -ChildPath posharm.psd1
Import-Module $modulePath

Describe "Add-ARMvariable" {
    New-ArmTemplate
    $newVar = @{
        Name = "Test"
        Value = "heihei"
    }

    $var = New-ARMvariable @newVar

    Context "Without pipeline" {
        Add-ARMvariable -InputObject $var
        $template = Get-ARMTemplate

        It "Should add a variable to a template" {        
            $template.variables.keys | should not be $null
        }

        It "Should have a key named [$($newVar.Name)]" {
            $template.variables.Test | should not be $null
        }
    }
    
    Context "With pipeline" {
        New-ArmTemplate

        $var | Add-ARMvariable
        $template = Get-ARMTemplate

        It "Should add a variable to a template" {        
            $template.variables.keys | should not be $null
        }

        It "Should have a key named [$($newParm.Name)]" {
            $template.variables.Test | should not be $null
        }
    }
}

Remove-Module -name posharm -ErrorAction SilentlyContinue