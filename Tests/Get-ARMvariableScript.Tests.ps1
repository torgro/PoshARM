#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. "$here\$sut"
#Import-Module "C:\Users\tore\Dropbox\SourceTreeRepros\PoshARM\PoshARM.psd1"

$modulePath = Split-Path $PSScriptRoot -Parent
$modulepath = Join-Path -Path $modulePath -ChildPath posharm.psd1
Import-Module $modulePath

Describe "Get-ARMvariableScript" {

    Context "Single variable added to template" {
        
        New-ARMTemplate
        $expected = @{
            Name = "test"
            Value = "foo-bar"
        }
        New-ARMvariable @expected | Add-ARMvariable

        $variableScript = Get-ARMtemplate | Select-Object -ExpandProperty variables | Get-ARMvariableScript
        $scriptBlock = [scriptblock]::Create($variableScript)

        New-ARMTemplate        

        It "Variables should be empty before script invoke" {
            ((Get-ARMtemplate).variables.psobject.properties | Measure-Object).Count | Should be 0
        }

        It "Invoking script should not throw" {
            {$scriptBlock.Invoke()} | Should not throw
        }

        $scriptBlock.Invoke()

        It "Invoking the script should create a new variable" {
            ((Get-ARMtemplate).variables.psobject.properties | Measure-Object).Count | Should be 1
        }

        It "Getting the variable should not throw" {
            { Get-ARMvariable -Name $expected.Name } | Should not throw
        }

        $actualVar = Get-ARMvariable -Name $expected.Name

        It "Should create a variable with name [$($expected.Name)]" {
            $actualVar.($expected.Name) | Should not be $null
        }

        It "Value of [$($expected.Name)] should be [$($expected.Value)]" {
            $actualVar.($expected.Name) | Should be $expected.Value
        }
    }
}

Remove-Module -name posharm -ErrorAction SilentlyContinue