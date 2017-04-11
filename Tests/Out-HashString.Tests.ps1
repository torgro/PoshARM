#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. "$here\$sut"

$modulePath = Split-Path $PSScriptRoot -Parent
$modulepath = Join-Path -Path $modulePath -ChildPath poshARM.psd1
Import-Module $modulePath

Describe "Out-HashString" {

    Context "Without Pipeline" {
        It "Should return an empty hashtable if input is not a hashtable" {
            $expected = "@{}"
            $actual = Out-HashString -InputObject "foo"
            $actual | Should Be $Expected
        }

        It "Should convert a hashtabel to a string representation" {
            $var = @{Test = "keyValue"}
            $Expected = '@{\r\n    Test = "keyValue"\r\n}' -replace ([regex]::Escape("\r\n")), [environment]::NewLine
            $actual = Out-HashString -InputObject $var
            $actual | Should Be $Expected
        }

        It "Should handle nested hashtables" {
            $var = @{Test = "keyValue"; Nested = @{Key1 = "Value1"; Key2 = "Value2"}}
            $Expected = '@{\r\n    Test = "keyValue"\r\n    Nested = @{\r\n        Key1 = "Value1"\r\n        Key2 = "Value2"\r\n    }\r\n}' -replace ([regex]::Escape("\r\n")), [environment]::NewLine
            $actual = Out-HashString -InputObject $var
            $actual | Should Be $Expected
        }
    }

    Context "With Pipeline" {
        It "Should return an empty hashtable if input is not a hashtable" {
            $expected = "@{}"
            $actual = "foo" | Out-HashString
            $actual | Should Be $Expected
        }

        It "Should convert a hashtabel to a string representation" {
            $var = @{Test = "keyValue"}
            $Expected = '@{\r\n    Test = "keyValue"\r\n}' -replace ([regex]::Escape("\r\n")), [environment]::NewLine
            $actual = $var | Out-HashString
            $actual | Should Be $Expected
        }

        It "Should handle nested hashtables" {
            $var = @{Test = "keyValue"; Nested = @{Key1 = "Value1"; Key2 = "Value2"}}
            $Expected = '@{\r\n    Test = "keyValue"\r\n    Nested = @{\r\n        Key1 = "Value1"\r\n        Key2 = "Value2"\r\n    }\r\n}' -replace ([regex]::Escape("\r\n")), [environment]::NewLine
            $actual = $var | Out-HashString
            $actual | Should Be $Expected
        }
    }    
}

Remove-Module -name posharm -ErrorAction SilentlyContinue