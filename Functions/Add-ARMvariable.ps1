function Add-ARMvariable
{
[cmdletbinding()]
Param(
    [Parameter(Mandatory, ValueFromPipeline)]
    [hashtable]$InputObject
    ,
    [hashtable]$Template
    ,
    [switch]$PassThru
)

Process
{
    if ($script:Template)
    {
        $script:Template.variables += $InputObject        
    }

    if ($Template)
    {
        $Template.variables += $InputObject
    }

    if ($PassThru.IsPresent)
    {
        $InputObject
    }
}

}