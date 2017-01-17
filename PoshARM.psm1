$script:Template = @{}

foreach ($function in (Get-ChildItem -file -Path(Join-Path -Path $PSScriptRoot -ChildPath .\functions)))
{
    Write-Verbose -Message "Importing function $($function.FullName)"
    . $function.FullName
}
