$script:Template = [PSCustomObject]@{}

foreach ($function in (Get-ChildItem -file -Path(Join-Path -Path $PSScriptRoot -ChildPath .\functions)))
{
    Write-Verbose -Message "Importing function $($function.FullName)"
    . $function.FullName
}



function Get-FunctionList
{
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
    $functionsString = ($functions.Name)  -join "','"
    $functionsString = "'$functionsString'"

    if ($AsString.IsPresent)
    {
        $functionsString
    }
    else
    {
        $functions
    }
}