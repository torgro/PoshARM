#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. "$here\$sut"

$modulePath = Split-Path $PSScriptRoot -Parent
$modulepath = Join-Path -Path $modulePath -ChildPath posharm.psd1
Import-Module $modulePath

New-ArmTemplate

$newVar = New-ARMvariable -Name test -Value testvalue | Add-ARMvariable -PassThru

$newVariableValue = @{
    Name = "test"
    Value = "newTestValue"
}

Describe "Set-ARMvariable" {
    Context "Without pipeline" {

        Set-ARMvariable -Name $newVariableValue.name -Value $newVariableValue.value
        $template = Get-ARMtemplate

        It "Should set the value to [$($newVariableValue.value)]" {
            $template.variables.test | Should Be $newVariableValue.value
        }
    }
}

Remove-Module -name posharm -ErrorAction SilentlyContinue