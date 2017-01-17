#Requires -Version 5.0
function Import-ARMtemplate
{
<#
.SYNOPSIS
    Import an ARM template.

.DESCRIPTION
    This Cmdlet imports an ARM template from a file or from a JSON-string. 

.PARAMETER JsonString
    A JSON string that is an ARM template

.PARAMETER FileName
    A file that contains a JSON ARM template

.EXAMPLE
    Get-ChildItem -Path .\TestFiles\SimpleVM.json | Import-ARMtemplate
    Get-ARMtemplate

.EXAMPLE
    # Copy an ARM template to the clipboard

    Get-ClipBoard | Import-ARMtemplate
    Get-ARMtemplate

.EXAMPLE
    Import-ARMtemplate -FileName .\TestFiles\SimpleVM.json
    Get-ARMtemplate

.INPUTS
    string

.OUTPUTS
    

.NOTES
    Author:  Tore Groneng
    Website: www.firstpoint.no
    Twitter: @ToreGroneng
#>
[cmdletbinding()]
Param(
    [Parameter(ValueFromPipeline, ParameterSetName="AsString")]
    [string]
    $JsonString
    ,
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName="FromFile")]
    [System.IO.FileInfo]
    [Alias("FullName")]
    $FileName
    ,
    [switch]$PassThru
)

Begin
{
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"
    $sb = New-Object System.Text.StringBuilder
}

Process
{
    if ($PSBoundParameters.ContainsKey("FileName"))
    {        
        $fileNameType = $FileName.GetType().Name
        if ($fileNameType -eq 'FileInfo')
        {
            $FileName = $FileName.FullName
        }        
        $JsonString = Get-Content -Path $FileName -Encoding UTF8            
    }

    if ($JsonString)
    {
        $null = $sb.Append($JsonString + [environment]::NewLine)
    }
}

End
{    
    if ($sb.Length -gt 0)
    {
        $jsonString = $sb.ToString()        
        Write-Verbose -Message "$f - $jsonString"
        
        $templateObject = $jsonString | ConvertFrom-Json

        if ($PassThru.IsPresent)
        {
            $templateObject
        }
        else
        {
            $script:Template = $templateObject
        }
    }
}

}