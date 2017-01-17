function Get-ARMvariableScript
{
[cmdletbinding()]
Param(
    [Parameter(ValueFromPipeline)]
    [PSCustomObject]$Variables
)

Begin
{
    $allVars = [ordered]@{}
}

Process
{    
    $allVars = $Variables | ConvertTo-Hash

    foreach ($key in $allVars.Keys)
    {
        $cmdLine = "New-ARMvariable -Name $key -Value " + '"' + $($allVars.$key) + '" | Add-ARMVariable'
        $cmdLine + [environment]::NewLine
    }
}

}
