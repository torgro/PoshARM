function Set-ARMvariable
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
    
    $allVariables = $script:Template.variables.Keys

    if ($allVariables)
    {
        $null = $NewDynParam.Add("ValidateSet",$allVariables)
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
        $script:Template.variables.$name = $Value
    }

    if ($Template)
    {
        $Template.variables.$name = $Value
    }
}
}