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
        $hash = New-ARMvariable -Name test -Value heihei

        It "Should create a simple hashtable with key test" {
            $hash.test | should not be $null
        }

        It "Should create a simple hashtable with key test and value [heihei]" {
            $hash.test | should be 'heihei'
        }

        It "Should only have one key" {
            $hash.keys.count | should be 1
        }
    }

    Context "Value from a hashtable" {
        $name = "subnet"
        $expectedHash = @{
            Name = "NameKey"
            Ipaddress = "10.0.0.2"
            SubNet = "255.255.255.0"
        }

        $var = New-ARMvariable -Name $name -HashValues $expectedHash

        It "Should create a variable called [$name]" {
            $var.keys -contains $name | should be $true
        }

        $actual = $var.$name

        It "Should have 3 keys" {
            $actual.keys.Count | should be 3
        }

        It "Should have a key [Name]" {
            $actual.ContainsKey("Name") | Should be $true
        }

        It "Value of [Name] should be [($expectedHash.Name)]" {
            $actual.Name | Should be $expectedHash.Name
        }

        It "Should have a key [Ipaddress]" {
            $actual.ContainsKey("Ipaddress") | Should be $true
        }

        It "Value of [Ipaddress] should be ]($expectedHash.Ipaddress)]" {
            $actual.Ipaddress | Should be $expectedHash.Ipaddress
        }

        It "Should have a key [SubNet]" {
            $actual.ContainsKey("SubNet") | Should be $true
        }

        It "Value of [SubNet] should be ]($expectedHash.SubNet)]" {
            $actual.SubNet | Should be $expectedHash.SubNet
        }
    }   

    Context "Object type" {
        $name = "subnet"
        $expectedHash = @{
            Name = "NameKey"
            Ipaddress = "10.0.0.2"
            SubNet = "255.255.255.0"
        }

        $var = New-ARMvariable -Name $name -HashValues $expectedHash

        It "Should create a OrderedDictionary object" {
            $var.Gettype().FullName | Should be "System.Collections.Specialized.OrderedDictionary"
        }
    } 
}

Remove-Module -name posharm -ErrorAction SilentlyContinue