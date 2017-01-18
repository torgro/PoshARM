#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. "$here\$sut"

$modulePath = Split-Path $PSScriptRoot -Parent
$modulepath = Join-Path -Path $modulePath -ChildPath posharm.psd1
Import-Module $modulePath

Describe "Get-ARMresourceScript" {

    Context "Single resource added to template" {

        New-ARMTemplate
        $expected = @{
            APIversion = '2016-03-30'
            Name = 'MyVM'          
            Type = 'Microsoft.Compute/virtualMachines'
        }

        New-ARMresource @expected | Add-ARMresource

        $resourceScript = Get-ARMtemplate | Select-Object -ExpandProperty resources | Get-ARMresourceScript
        $scriptBlock = [scriptblock]::Create($resourceScript)

        New-ARMTemplate

        It "Resources should be empty before script invoke" {
            (Get-ARMtemplate).resources.Count | Should be 0
        }

        It "Invoking script should not throw" {
            {$scriptBlock.Invoke()} | Should not throw
        }

        New-ARMTemplate
        $scriptBlock.Invoke()

        It "Invoking the script should create a new resource" {
            ((Get-ARMtemplate).resources | Measure-Object).Count | Should be 1
        }

        It "Getting the resource should not throw" {
            { Get-ARMtemplate | Select-Object -Property resources | Select-Object -First 1 } | Should  not throw
        }

        $actualResource = Get-ARMtemplate | Select-Object -ExpandProperty resources | Select-Object -First 1

        It "Should create a resource with name [$($expected.Name)]" {
            $actualResource.Name | Should Be $expected.Name
        }

        It "Value of type should be [$($expected.Type)]" {
            $actualResource.Type | Should be $expected.Type
        }
    }
}

Remove-Module -name posharm -ErrorAction SilentlyContinue