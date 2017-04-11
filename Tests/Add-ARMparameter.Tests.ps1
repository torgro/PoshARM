#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. "$here\$sut"
#Import-Module C:\Users\tore\Dropbox\SourceTreeRepros\PoshARM

$modulePath = Split-Path $PSScriptRoot -Parent
$modulepath = Join-Path -Path $modulePath -ChildPath posharm.psd1
Import-Module $modulePath

Describe "Add-ARMparameter" {

    $expected = @{
        Name = 'Resource'
        Type = 'string'
        DefaultValue = 'meh'
        AllowedValues = @("meh", "det", "foo")
        MinValue = 1
        MaxValue = 3
        MinLength = '3'
        MaxLength = '99'
        Description = 'Description'
        Metadata = @{Comment = "yalla"}
    }

    $actual = New-ARMparameter @expected
    New-ArmTemplate

    Context "Without pipeline" {
        Add-ARMparameter -InputObject $actual
        $template = Get-ARMTemplate

        It "Should add a parameter to a template" {        
            $template.parameters | should not be $null
        }

        It "Should have a property named [$($expected.Name)]" {
            $template.parameters.($expected.Name) | should not be $null
        }
    }
    
    Context "With pipeline" {
        New-ArmTemplate

        $actual | Add-ARMparameter
        $template = Get-ARMTemplate

        It "Should add a parameter to a template" {        
            $template.parameters | should not be $null
        }

        It "Should have a property named [$($expected.Name)]" {
            $template.parameters.($expected.Name) | should not be $null
        }
    }
}

Remove-Module -name posharm -ErrorAction SilentlyContinue