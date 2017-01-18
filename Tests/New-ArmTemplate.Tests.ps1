#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. "$here\$sut"

$modulePath = Split-Path $PSScriptRoot -Parent
$modulepath = Join-Path -Path $modulePath -ChildPath poshARM.psd1
Import-Module $modulePath

Describe "New-ARMTemplate" {
    Context "Create Object" {
        $new = New-ArmTemplate
        It "Should return nothing if Passthru is not specified" {            
            $new | Should Be $null
        }

        It "Should save the template in the Script:Template variable" {
            Get-ARMTemplate | should not be $null
        }

        It "Should have a [contentVersion] proptery" {
            (Get-ARMTemplate).contentVersion | Should be '1.0.0.0'
        }

        It "Should have a [parameters] property of type [PScustomobject]" {
             (Get-ARMTemplate).parameters.GetType().Name | Should be 'PScustomobject'
        }

        It "Should have a [variables] property of type [PScustomobject]" {
             (Get-ARMTemplate).variables.GetType().Name | Should be 'PScustomobject'
        }

        It "Should have a [resources] property of type Object[]" {
             (Get-ARMTemplate).resources.GetType().Name | Should be 'Object[]'
        }

        It "Should have a [outputs] property of type [PScustomobject]" {
             (Get-ARMTemplate).outputs.GetType().Name | Should be 'PScustomobject'
        }

        It "Should return an object if Passthru is specified" {
            $new = New-ArmTemplate -Passthru
            $new | Should not Be $null
        }
    }    
}

Remove-Module -name posharm -ErrorAction SilentlyContinue