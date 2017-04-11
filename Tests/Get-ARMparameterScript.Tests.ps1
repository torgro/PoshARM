#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. "$here\$sut"

$modulePath = Split-Path $PSScriptRoot -Parent
$modulepath = Join-Path -Path $modulePath -ChildPath posharm.psd1
Import-Module $modulePath

Describe "Get-ARMparameterScript" {
    
    Context "Single parameter added to template" {
        
        New-ARMTemplate
        $ExpectedParm = @{
            Name = 'adminUserName'
            Type = 'string'
        }

        $paramScript = Get-ARMtemplate | Select-Object -ExpandProperty parameters | Get-ARMparameterScript
        $scriptBlock = [scriptblock]::Create($paramScript)

        New-ARMTemplate

        It "Parameters should be empty before script invoke" {
            ((Get-ARMtemplate).parameters.psobject.properties | Measure-Object).Count | Should be 0
        }

        It "Invoking script should not throw" {
            {$scriptBlock.Invoke()} | Should not throw
        }

        New-ARMTemplate
        $scriptBlock.Invoke()

        It "Invoking the script should create a new variable" {
            ((Get-ARMtemplate).parameters.psobject.properties | Measure-Object).Count | Should be 1
        }

        It "Getting the parameter should not throw" {
            { Get-ARMparameter -Name $ExpectedParm.Name } | Should not throw
        }

        $actualParam = Get-ARMparameter -Name $ExpectedParm.Name

        It "Should create a parameter with name [$($ExpectedParm.Name)]" {
            $actualParam.($ExpectedParm.Name) | Should not be $null
        }

        It "Type of [$($ExpectedParm.Name)] should be [$($ExpectedParm.Type)]" {
            $actualParam.($ExpectedParm.Name).Type | Should be $ExpectedParm.Type
        }
    }
}

Remove-Module -name posharm -ErrorAction SilentlyContinue