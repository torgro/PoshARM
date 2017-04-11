$script:Template = [PSCustomObject]@{}

foreach ($file in (Get-ChildItem -file -Path(Join-Path -Path $PSScriptRoot -ChildPath .\functions))) {
    . ([Scriptblock]::Create([System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)))
}

function Get-FunctionList {
    <#
.SYNOPSIS
    Internal function

.DESCRIPTION
    Internal function

.NOTES
    Author:  Tore Groneng
    Website: www.firstpoint.no
    Twitter: @ToreGroneng
#>
    Param(
        [switch]
        $AsString
    )
    $functions = (Get-Command -Module posharm | Select-Object -Property Name)
    $functionsString = ($functions.Name) -join "','"
    $functionsString = "'$functionsString'"

    if ($AsString.IsPresent) {
        $functionsString
    }
    else {
        $functions
    }
}