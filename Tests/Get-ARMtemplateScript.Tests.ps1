#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. "$here\$sut"

$modulePath = Split-Path $PSScriptRoot -Parent
$modulepath = Join-Path -Path $modulePath -ChildPath posharm.psd1
Import-Module $modulePath

Describe "Get-ARMtemplateScript" {

    Context "Single variable added to template" {
        
        New-ARMTemplate
        $expected = @{
            Name = "test"
            Value = "foo-bar"
        }
        New-ARMvariable @expected | Add-ARMvariable

        $variableScript = Get-ARMtemplate | Get-ARMtemplateScript
        $scriptBlock = [scriptblock]::Create($variableScript)

        It "Invoking the script should not throw" {
            { $scriptBlock.Invoke() } | Should Not Throw
        }

        It "Invoking the script should create a new variable" {
             ((Get-ARMtemplate).variables.psobject.properties | Measure-Object).Count | Should be 1
        }
    }
}

Remove-Module -name posharm -ErrorAction SilentlyContinue