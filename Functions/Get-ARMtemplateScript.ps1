function Get-ARMtemplateScript
{
[cmdletbinding()]
Param(
    [Parameter(ValueFromPipeline)]
    [pscustomobject]$Template
)

Begin
{
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"
}

Process
{    
    if ($Template)
    {        
        'New-ARMtemplate'
        ''

        $Template.variables | Get-ARMvariableScript
        $Template.parameters | Get-ARMparameterScript

        foreach ($resource in $Template.resources)
        {
            $resource | Get-ARMresourceScript
        }       
    }
}

}