#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. "$here\$sut"

$modulePath = Split-Path $PSScriptRoot -Parent
$modulepath = Join-Path -Path $modulePath -ChildPath posharm.psd1
Import-Module $modulePath

Describe "New-ARMparameter" {

    $ExpectedParm = @{
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

    $actualParameter = New-ARMparameter @ExpectedParm

    Context "Create object" {

        $actual = $actualParameter.($ExpectedParm.Name)

        It "Should create a new parameter object" {
            $actualParameter | Should not Be $null
        }

        It "Should be of type [PScustomObject]" {
            $actualParameter.GetType().Name | Should be "PScustomObject"
        }

        It "Should create a PSCustomObject with PStypeName 'ARMparameter'" {
            $actualParameter.pstypenames[0] | Should be "ARMparameter"
        }

        It "Should create a property with name [$($ExpectedParm.Name)]" {
            $actual | Should not be $null
        }

        it "Should have a type with value [$($ExpectedParm.Type)]" {
            $actual.Type | Should be $ExpectedParm.Type
        }        

        It "Should have an DefaultValue of [$($ExpectedParm.DefaultValue)]" {
            $actual.DefaultValue | Should be $ExpectedParm.DefaultValue
        }

        $actualValue = $actual.AllowedValues -join ""
        $expectedValue = $ExpectedParm.AllowedValues -join ""

        It "Should have AllowedValues equal [$expectedValue]" {
            $actualValue | Should be $expectedValue
        }

        It "Should have an MinValue of [$($ExpectedParm.MinValue)]" {
            $actual.MinValue | Should be $ExpectedParm.MinValue
        }

        It "Should have an MaxValue [$($ExpectedParm.MaxValue)]" {
            $actual.MaxValue | Should be $ExpectedParm.MaxValue
        }

        It "Should have an MinLength [$($ExpectedParm.MinLength)]" {
            $actual.MinLength | Should be $ExpectedParm.MinLength
        }
        
        It "Should have an MaxLength [$($ExpectedParm.MaxLength)]" {
            $actual.MaxLength | Should be $ExpectedParm.MaxLength
        }

        $meta = $actual.MetaData

        It "Should have a MetaData property [$(($meta | Out-HashString) -replace [environment]::NewLine,'')]" {
            $meta | should not be $null
        }

        It "MetaData should be of type [PScustomObject]" {
            $meta.GetType().Name | Should be "PScustomObject"
        }

        It "MetaData should have an Comment property with value [$($ExpectedParm.Metadata.Comment)]" {
            $meta.Comment | Should be $ExpectedParm.Metadata.Comment
        }

        It "MetaData should have an Description property with value [$($ExpectedParm.Description)]" {
            $meta.Description | Should be $ExpectedParm.Description
        }       
    }    
}

Remove-Module -name posharm -ErrorAction SilentlyContinue