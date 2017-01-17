function Import-ARMtemplate
{
[cmdletbinding()]
Param(
    [Parameter(ValueFromPipeline, ParameterSetName="AsString")]
    [string]$JsonString
    ,
    [Parameter(ParameterSetName="FromFile")]
    $FileName
    ,
    [switch]$PassThru
)

Begin
{
    $sb = New-Object System.Text.StringBuilder
}

Process
{
    if ($PSBoundParameters.ContainsKey("FileName"))
    {
        if (Test-Path -Path $FileName -ErrorAction Stop)
        {
            $JsonString = Get-Content -Path $FileName -Encoding UTF8
        }        
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
        $templateObject = $jsonString | ConvertFrom-Json

        if ($PassThru.IsPresent)
        {
            $templateObject #| ConvertTo-Hash
        }
        else
        {
            $script:Template = $templateObject #| ConvertTo-Hash
        }
    }
}

}