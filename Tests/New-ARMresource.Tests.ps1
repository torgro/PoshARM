#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. "$here\$sut"
#Import-Module C:\Users\tore\Dropbox\SourceTreeRepros\PoshARM
$modulePath = Split-Path $PSScriptRoot -Parent
$modulepath = Join-Path -Path $modulePath -ChildPath poshARM.psd1
Import-Module $modulePath

Describe "New-ARMresource" {
   
    $expected = @{
        APIversion = '2016-03-30'
        Name = 'MyVM'
        Location = 'EAST-US'
        Tags = @{tag = 1}
        Comments = 'hey'
        DependsOn = @("item1", "item2")
        SKU = @{value = "skuvalue"}
        Kind = 'storage'
        Properties = @{prop1 = 1}
        Type = 'Microsoft.Compute/virtualMachines'
    }

    $Actual = New-ARMresource @expected

    Context "Create object" {

        It "Should create a new resource object" {
            $Actual | Should not Be $null
        }

        It "Should be of type [PSCustomObject]" {
            $Actual.GetType().Name | Should be "PSCustomObject"
        }

        It "Should create a PSCustomObject with PStypeName 'ARMresource'" {
            $Actual.pstypenames[0] | should be "ARMresource"
        }

        It "Should have an APIversion [$($expected.APIversion)]" {
            $Actual.APIversion | Should be $expected.APIversion
        }

        It "Should have an Name [$($expected.Name)]" {
            $Actual.Name | Should be $expected.Name
        }

        It "Should have an Location [$($expected.Location)]" {
            $Actual.Location | Should be $expected.Location
        }
        
        It "Should have a Tag [$($expected.Tags.tag)]" {
            $Actual.tags.tag | Should be $expected.Tags.tag
        }

        It "Should have a Comment [$($expected.Comments)]" {
            $Actual.Comments | Should be $expected.Comments
        }
        
        It "Should have a DependsOn [$($expected.DependsOn)]" {
            $Actual.DependsOn | Should be $expected.DependsOn
        }
        
        It "Should have a SKU [$($expected.SKU)]" {
            $Actual.SKU | Should be $expected.SKU
        }

        It "Should have a Kind [$($expected.Kind)]" {
            $Actual.Kind | Should be $expected.Kind
        }
        
        It "Should have a Properties [$($expected.Properties.Prop)]" {
            $Actual.Properties.Prop | Should be $expected.Properties.Prop
        }

        It "Should have a Type [$($expected.Type)]" {
            $Actual.Type | Should be $expected.Type
        }        
    }    
}

Remove-Module -name posharm -ErrorAction SilentlyContinue