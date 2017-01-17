#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. "$here\$sut"

$modulePath = Split-Path $PSScriptRoot -Parent
$modulepath = Join-Path -Path $modulePath -ChildPath posharm.psd1
Import-Module $modulePath

Describe "New-ARMparameter" {

    $newParm = @{
        Name = 'Resource'
        Type = 'string'
        DefaultValue = 'meh'
        AllowedValues = @("meh", "det","foo")
        MinValue = 1
        MaxValue = 3
        MinLength = '3'
        MaxLength = '99'
        Description = 'Description'
        Metadata = @{Comment="yalla"}
    }

    $parameter = New-ARMparameter @newParm

    Context "Create object" {
        It "Should create a new parameter object" {
            $parameter | Should not Be $null
        }

        It "Should be of type [Hashtable]" {
            $parameter.GetType().Name | Should be "Hashtable"
        }

        It "Should have one key [$($newParm.Name)]" {
            $parameter.keys.count | should be 1
        }

        it "Should have a key named [$($newParm.Name)]" {
            $parameter.keys | Should be $newParm.Name
        }

        $param = $parameter.($newParm.Name)

        It "Should have an Type [$($newParm.Type)]" {
            $param.Type | Should be $newParm.Type
        }

        It "Should have an DefaultValue [$($newParm.DefaultValue)]" {
            $param.DefaultValue | Should be $newParm.DefaultValue
        }

        It "Should have an AllowedValues [$($newParm.AllowedValues -join ",")]" {
            $expected = '"' + ($newParm.AllowedValues -join "','") + '"'
            $actual = '"' + ($param.AllowedValues -join "','") + '"'
            $actual | Should be $expected
        }

        It "Should have an MinValue [$($newParm.MinValue)]" {
            $param.MinValue | Should be $newParm.MinValue
        }

        It "Should have an MaxValue [$($newParm.MaxValue)]" {
            $param.MaxValue | Should be $newParm.MaxValue
        }

        It "Should have an MinLength [$($newParm.MinLength)]" {
            $param.MinLength | Should be $newParm.MinLength
        }
        
        It "Should have an MaxLength [$($newParm.MaxLength)]" {
            $param.MaxLength | Should be $newParm.MaxLength
        }

        $meta = $param.MetaData

        It "Should have a MetaData property [$(($meta | Out-HashString) -replace [environment]::NewLine,'')]" {
            $meta | should not be $null
        }

        It "MetaData should be of type [Hashtable]" {
            $meta.GetType().Name | Should be "Hashtable"
        }

        It "MetaData should have an Comment key with value [$($newParm.Metadata.Comment)]" {
            $meta.Comment | Should be $newParm.Metadata.Comment
        }

        It "MetaData should have an Description key with value [$($newParm.Description)]" {
            $meta.Description | Should be $newParm.Description
        }       
    }    
}

Remove-Module -name posharm -ErrorAction SilentlyContinue