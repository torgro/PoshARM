function Add-ARMresource
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
        $script:Template.resources += $InputObject        
    }

    if ($Template)
    {
        $Template.resources += $InputObject
    }

    if ($PassThru.IsPresent)
    {
        $InputObject
    }
}
}