#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. "$here\$sut"
#Import-Module C:\Users\tore\Dropbox\SourceTreeRepros\PoshARM

$modulePath = Split-Path $PSScriptRoot -Parent
$modulepath = Join-Path -Path $modulePath -ChildPath posharm.psd1
Import-Module $modulePath

Describe "Add-ARMparameter" {
    $newParm = @{
        Name = 'Resource'
        Type = 'string'
        DefaultValue = 'meh'
        AllowedValues = @("meh", "det", "foo")
        MinValue = 1
        MaxValue = 3
        MinLength = '3'
        MaxLength = '99'
        Description = 'Description'
        Metadata = @{Comment="yalla"}
    }

    $parameter = New-ARMparameter @newParm
    New-ArmTemplate

    Context "Without pipeline" {
        Add-ARMparameter -InputObject $parameter
        $template = Get-ARMTemplate

        It "Should add a parameter to a template" {        
            $template.parameters.keys | should not be $null
        }

        It "Should have a key named [$($newParm.Name)]" {
            $template.parameters.Resource | should not be $null
        }
    }
    
    Context "With pipeline" {
        New-ArmTemplate

        $parameter | Add-ARMparameter
        $template = Get-ARMTemplate

        It "Should add a parameter to a template" {        
            $template.parameters.keys | should not be $null
        }

        It "Should have a key named [$($newParm.Name)]" {
            $template.parameters.Resource | should not be $null
        }
    }
}

Remove-Module -name posharm -ErrorAction SilentlyContinue