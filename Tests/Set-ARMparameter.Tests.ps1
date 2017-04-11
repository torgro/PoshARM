#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. "$here\$sut"

$modulePath = Split-Path $PSScriptRoot -Parent
$modulepath = Join-Path -Path $modulePath -ChildPath posharm.psd1
Import-Module $modulePath

New-ArmTemplate

$newParameterValue = @{
    Type = "int"
    DefaultValue = "test"
}

Describe "Set-ARMparameter" {

    Context "Without pipeline" {

        Set-ARMparameter -Name test -Value $newParameterValue
        $template = Get-ARMtemplate

        It "Should set the type to [$($newParameterValue.type)]" {
            $template.parameters.test.type | Should Be $newParameterValue.type
        }

        It "Should set the DefaultValue to [$($newParameterValue.DefaultValue)]" {
            $template.parameters.test.defaultvalue | should be $newParameterValue.DefaultValue
        }
    }
}

Remove-Module -name posharm -ErrorAction SilentlyContinue