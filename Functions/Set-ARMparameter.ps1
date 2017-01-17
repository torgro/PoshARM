function Set-ARMparameter
{
[cmdletbinding()]
Param(    
    [Parameter(Mandatory)]
    $Value
    ,
    [Parameter(ValueFromPipeline)]
    [hashtable]$Template
)
DynamicParam
{
    $Dictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

    $NewDynParam = @{
        Name = "Name"            
        Mandatory = $true
        ValueFromPipelineByPropertyName = $true
        ValueFromPipeline = $false
        DPDictionary = $Dictionary            
    }

    #ParameterSetName = "__AllParameterSets"
    
    $allParameters = $script:Template.parameters.Keys

    if ($allParameters)
    {
        $null = $NewDynParam.Add("ValidateSet",$allParameters)
    }
    else
    {
        $null = $NewDynParam.Add("ValidateSet",@("-"))
    }

    New-DynamicParam @NewDynParam
    $Dictionary
}

Process
{
    $name = $PSBoundParameters.Name    

    if ($script:Template)
    {
        $script:Template.parameters.$name = $Value
    }

    if ($Template)
    {
        $Template.parameters.$name = $Value
    }
}

}