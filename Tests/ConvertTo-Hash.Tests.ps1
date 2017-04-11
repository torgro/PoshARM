#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. "$here\$sut"

#$path = "C:\Users\tore\Dropbox\SourceTreeRepros\PoshARM\PoshARM.psd1"
#Import-Module $path

$modulePath = Split-Path $PSScriptRoot -Parent
$modulepath = Join-Path -Path $modulePath -ChildPath posharm.psd1
Import-Module $modulePath

Describe "ConvertTo-Hash" {

    $simpleObject = [pscustomobject]@{
        Name = "Tore"
        Age = 45
    }

    $nestedObject = [pscustomobject]@{
        Name = "Tore"
        Address = @{
            Street = "TimesSquare 1"
            City = "New York"
        }
    }

    Context "Without pipeline" {
        $hash = ConvertTo-Hash -InputObject $simpleObject
        $nestedHash = ConvertTo-Hash -InputObject $nestedObject

        It "Should be a OrderedDictionary object type" {
            $hash.GetType().Name | should be "OrderedDictionary"
        }

        It "Should have a Name Key" {
            $hash.Name | Should be $simpleObject.Name
        }

        It "Should have a Age Key" {
            $hash.Age | Should be $simpleObject.Age
        }

        It "Should create a nested hashtable" {
            $nestedHash.Address | should not be $null
        }

        It "Should create a hashtable object" {
            $nestedHash.Address.GetType().Name | Should be "hashtable"
        }

        It "Should have a street address [$($nestedObject.Address.Street)]" {
            $nestedHash.Address.Street | should be $nestedObject.Address.Street
        }

        It "Should have a city address [$($nestedObject.Address.City)]" {
            $nestedHash.Address.City | should be $nestedObject.Address.City
        }

        
    }

    Context "With pipeline" {
        $hash = $null
        $nestedHash = $null
        $hash = $simpleObject | ConvertTo-Hash
        $nestedHash = $nestedObject | ConvertTo-Hash

        It "Should be a OrderedDictionary object type" {
            $hash.GetType().Name | should be "OrderedDictionary"
        }

        It "Should have a Name Key" {
            $hash.Name | Should be $simpleObject.Name
        }

        It "Should have a Age Key" {
            $hash.Age | Should be $simpleObject.Age
        }

        It "Should create a nested hashtable" {
            $nestedHash.Address | should not be $null
        }

        It "Should create a hashtable object" {
            $nestedHash.Address.GetType().Name | Should be "hashtable"
        }

        It "Should have a street address [$($nestedObject.Address.Street)]" {
            $nestedHash.Address.Street | should be $nestedObject.Address.Street
        }

        It "Should have a city address [$($nestedObject.Address.City)]" {
            $nestedHash.Address.City | should be $nestedObject.Address.City
        }
    }

    Context "Array handling with pipeline" {
        
        $array = @()
        foreach ($int in (1..2)) {
            $array += [PSCustomObject]@{
                Number = $int
                Name = "My name is $int"
            }
        }
        $arrayObj = [pscustomobject]@{ArrayItem = $array}
        $assert = $arrayObj | ConvertTo-Hash

        It "arrayObj should be a PSCustomObject" {
            $arrayObj.GetType().Name | Should be "PSCustomObject"            
        }

        It "Value of ArrayItem should be of type Array" {
            $arrayObj.ArrayItem -is [array] | Should be $true
        }

        it "Should convert the array to a collection of OrderedDictionary" {
            $assert.GetType().Name | Should be "OrderedDictionary"
        }

        $index = 0
        foreach ($hashItem in $assert.ArrayItem) {
            It "Should have a collection of OrderedDictionary values" {
                $hashItem.GetType().Name | Should Be "OrderedDictionary"
            }

            It "Should have Number key with value [$($arrayObj.ArrayItem[$index].Number)]" {
                $hashItem.Number | Should be $arrayObj.ArrayItem[$index].Number
            }
            $index++
        }     
    }

    Context "Array handling without pipeline" {
        
        $array = @()
        foreach ($int in (1..2)) {
            $array += [PSCustomObject]@{
                Number = $int
                Name = "My name is $int"
            }
        }
        $arrayObj = [pscustomobject]@{ArrayItem = $array}
        $assert = ConvertTo-Hash -InputObject $arrayObj

        It "arrayObj should be a PSCustomObject" {
            $arrayObj.GetType().Name | Should be "PSCustomObject"            
        }

        It "Value of ArrayItem should be of type Array" {
            $arrayObj.ArrayItem -is [array] | Should be $true
        }

        it "Should convert the array to a collection of OrderedDictionary" {
            $assert.GetType().Name | Should be "OrderedDictionary"
        }

        $index = 0
        foreach ($hashItem in $assert.ArrayItem) {
            It "Should have a collection of OrderedDictionary values" {
                $hashItem.GetType().Name | Should Be "OrderedDictionary"
            }

            It "Should have Number key with value [$($arrayObj.ArrayItem[$index].Number)]" {
                $hashItem.Number | Should be $arrayObj.ArrayItem[$index].Number
            }
            $index++
        }     
    }

    Context "Passthrou Hashtable with pipeline" {
        $hash = @{test = 1}
        $assert = $hash | ConvertTo-Hash
        It "Should Passthrou inputobject if it is a hashtable" {            
            $assert.GetType().Name | Should be "hashtable"
        }

        It "Should have a test key with value [1]" {
            $assert.test | should be 1
        }
    }

    Context "Passthrou OrderedDictionary with pipeline" {
        $ordered = [ordered]@{test = 1}
        $assert = $ordered | ConvertTo-Hash

        It "Should Passthrou inputobject if it is a OrderedDictionary" {            
            $assert.GetType().Name | Should be "OrderedDictionary"
        }

        It "Should have a test key with value [1]" {
            $assert.test | should be 1
        }
    }

    Context "Passthrou Hashtable without pipeline" {
        $hash = @{test = 1}
        $assert = ConvertTo-Hash -InputObject $hash

        It "Should Passthrou inputobject if it is a hashtable" {            
            $assert.GetType().Name | Should be "hashtable"
        }

        It "Should have a test key with value [1]" {
            $assert.test | should be 1
        }
    }

    Context "Passthrou OrderedDictionary without pipeline" {
        $ordered = [ordered]@{test = 1}
        $assert = ConvertTo-Hash -InputObject $ordered

        It "Should Passthrou inputobject if it is a OrderedDictionary" {            
            $assert.GetType().Name | Should be "OrderedDictionary"
        }

        It "Should have a test key with value [1]" {
            $assert.test | should be 1
        }
    }
}

Remove-Module -name posharm -ErrorAction SilentlyContinue