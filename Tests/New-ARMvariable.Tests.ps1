#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. "$here\$sut"
#$path = "C:\Users\tore\Dropbox\SourceTreeRepros\PoshARM\PoshARM.psd1"
#Import-Module $path

$modulePath = Split-Path $PSScriptRoot -Parent
$modulepath = Join-Path -Path $modulePath -ChildPath poshARM.psd1
Import-Module $modulePath

Describe "New-ARMvariable" {

    Context "Simple name value tests" {
        $Expected = @{
            Name = "test"
            Value = "foo-bar"
        }
        $ActualVar = New-ARMvariable @Expected

        It "Should create a PSCustomObject" {
            $ActualVar.GetType().Name | Should Be "PSCustomObject"
        }

        It "Should create a PSCustomObject with PStypeName 'ARMvariable'" {
            $ActualVar.pstypenames[0] | should be "ARMvariable"
        }

        It "Should create a property [$($Expected.Name)]" {
            $ActualVar.($Expected.Name) | should not be $null
        }

        It "Property [$($Expected.Name)] should have value [$($Expected.Value)]" {
            $ActualVar.($Expected.Name) | should be $Expected.Value
        }
    }

    Context "Value from a hashtable" {
        $name = "subnet"
        $expected = @{
            Name = "NameKey"
            Ipaddress = "10.0.0.2"
            SubNet = "255.255.255.0"
        }

        $ActualVar = New-ARMvariable -Name $name -HashValues $expected

        It "Should create a PSCustomObject" {
            $ActualVar.GetType().Name | Should Be "PSCustomObject"
        }

        It "Should create a PSCustomObject with PStypeName 'ARMvariable'" {
            $ActualVar.pstypenames[0] | should be "ARMvariable"
        }

        It "Should have a Property [$name]" {
            $ActualVar | Select-Object -ExpandProperty $name | Should not be $null
        }

        $actual = $ActualVar.$name

        It "Should have 3 properties" {
            $ActualVar.$name.psobject.Properties.Name.Count | should be 3
        }        

        It "Value of [Name] should be [$($expected.Name)]" {
            $actual.Name | Should be $expected.Name
        }

        It "Value of [Ipaddress] should be [$($expected.Ipaddress)]" {
            $actual.Ipaddress | Should be $expected.Ipaddress
        }

        It "Value of [SubNet] should be ]$($expected.SubNet)]" {
            $actual.SubNet | Should be $expected.SubNet
        }
    }   
}

Remove-Module -Name PoshARM -ErrorAction SilentlyContinue