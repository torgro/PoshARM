#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. "$here\$sut"

$modulePath = Split-Path $PSScriptRoot -Parent
$modulepath = Join-Path -Path $modulePath -ChildPath posharm.psd1
Import-Module $modulePath

Describe "Add-ARMresource" {
    New-ArmTemplate

    $expected = @{
        APIversion = '2016-03-30'
        Name = 'MyVM'
        Location = 'EAST-US'
        Tags = @{tag=1}
        Comments = 'hey'
        DependsOn = @("item1","item2")
        SKU = @{name="Standard_LRS"}
        Kind = 'storage'
        Properties = @{prop1=1}
        Type = 'Microsoft.Compute/virtualMachines'
    }

    $actual = New-ARMresource @expected    

    Context "Without pipeline" {

        Add-ARMresource -InputObject $actual
        $template = Get-ARMTemplate

        It "Should add a resource to a template" {        
            $template.resources.count | should be 1
        }

        $actualResource = $template.resources[0]

        It "Should have name property with value [$($expected.Name)]" {            
            $actualResource.name | should be $expected.Name
        }

        It "Should be of type Array" {
            $template.resources -is [array] | Should be $true
        }
    }
    
    Context "With pipeline" {
        New-ArmTemplate

        $actual | Add-ARMresource
        $template = Get-ARMTemplate

        It "Should add a resource to a template" {        
            $template.resources.count | should be 1
        }

        $actualResource = $null
        $actualResource = $template.resources[0]

        It "Should have name property with value [$($expected.Name)]" {
            $actualResource.name | should be $expected.Name
        }

        It "Should be of type Array" {
            $template.resources -is [array] | Should be $true
        }
    }
}

Remove-Module -name posharm -ErrorAction SilentlyContinue
