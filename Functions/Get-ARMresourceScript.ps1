#Requires -Version 5.0
function Get-ArmResourceScript {
    <#
.SYNOPSIS
    Get the Powershell script that will recreate the resources in the ARM template

.DESCRIPTION
    Get the Powershell script that will recreate the resources in the ARM template. This cmdlet is invoked by the Get-ARMtemplateScript cmdlet.

.PARAMETER Resources
    The resources propterty of the ARM template

.EXAMPLE
    Get-ARMtemplate | Select-Object resources | Get-ARMresourceScript

.INPUTS
    PSCustomObject

.OUTPUTS
    string

.NOTES
    Author:  Tore Groneng
    Website: www.firstpoint.no
    Twitter: @ToreGroneng
#>
    [cmdletbinding()]
    Param(
        [Parameter(ValueFromPipeline)]
        [PSCustomObject]
        $Resources
    )

    Begin {
        $f = $MyInvocation.InvocationName
        Write-Verbose -Message "$f - START"

        $cmd = Get-Command -Name New-ARMresource
        $cmdParams = $cmd.Parameters.Keys
    }

    Process {
        foreach ($resource in $Resources) {
            $hash = $resource | ConvertTo-Hash
            $cmdline = '$resource = '

            foreach ($key in $hash.Keys) {
                if ($key -notin $cmdParams) {
                    Write-Warning -Message "Parameter [$key] not found in $($cmd.Name)"
                }
            }

            $params = $hash | Out-HashString
            $cmdline = "$cmdline$params" + [environment]::NewLine
            "$cmdline" + "New-ARMresource @resource | Add-ARMresource" + [environment]::NewLine + [environment]::NewLine
        }
    }
}