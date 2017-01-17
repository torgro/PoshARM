#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. "$here\$sut"
#Import-Module C:\Users\tore\Dropbox\SourceTreeRepros\PoshARM
$modulePath = Split-Path $PSScriptRoot -Parent
$modulepath = Join-Path -Path $modulePath -ChildPath poshARM.psd1
Import-Module $modulePath

Describe "New-ARMresource" {
   
    $newRes = @{
        APIversion = '2016-03-30'
        Name = 'MyVM'
        Location = 'EAST-US'
        Tags = @{tag=1}
        Comments = 'hey'
        DependsOn = @("item1","item2")
        SKU = "skuvalue"
        Kind = 'storage'
        Properties = @{prop1=1}
        #Resources = ''
        Type = 'Microsoft.Compute/virtualMachines'
    }

    $resource = New-ARMresource @newRes

    Context "Create object" {
        It "Should create a new resource object" {
            $resource | Should not Be $null
        }

        It "Should be of type [OrderedDictionary]" {
            $resource.GetType().Name | Should be "OrderedDictionary"
        }

        It "Should have an APIversion [$($newRes.APIversion)]" {
            $resource.APIversion | Should be $newRes.APIversion
        }

        It "Should have an Name [$($newRes.Name)]" {
            $resource.Name | Should be $newRes.Name
        }

        It "Should have an Location [$($newRes.Location)]" {
            $resource.Location | Should be $newRes.Location
        }
        
        It "Should have a Tag [$($newRes.Tags.tag)]" {
            $resource.tags.tag | Should be $newRes.Tags.tag
        }

        It "Should have a Comment [$($newRes.Comments)]" {
            $resource.Comments | Should be $newRes.Comments
        }
        
        It "Should have a DependsOn [$($newRes.DependsOn)]" {
            $resource.DependsOn | Should be $newRes.DependsOn
        }
        
        It "Should have a SKU [$($newRes.SKU)]" {
            $resource.SKU | Should be $newRes.SKU
        }

        It "Should have a Kind [$($newRes.Kind)]" {
            $resource.Kind | Should be $newRes.Kind
        }
        
        It "Should have a Properties [$($newRes.Properties.Prop)]" {
            $resource.Properties.Prop | Should be $newRes.Properties.Prop
        }

        It "Should have a Type [$($newRes.Type)]" {
            $resource.Type | Should be $newRes.Type
        }
        
    }
    
}

Remove-Module -name posharm -ErrorAction SilentlyContinue