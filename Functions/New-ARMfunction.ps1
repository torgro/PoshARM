function New-ArmFunction {
    [cmdletbinding()]
    [outputtype([string])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    Param(
        [switch]$ConCat
        ,
        [string[]]$Values
    )
    DynamicParam {
        $Dictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        $NewDynParam = @{
            Name = "Variable"
            Mandatory = $false
            ValueFromPipelineByPropertyName = $true
            ValueFromPipeline = $false
            DPDictionary = $Dictionary
        }

        $allVars = $script:Template.variables.Keys

        if ($allVars) {
            $null = $NewDynParam.Add("ValidateSet", $allVars)
        }
        else {
            $null = $NewDynParam.Add("ValidateSet", @("-"))
        }

        New-DynamicParam @NewDynParam

        $NewDynParam.Name = "Parameter"
        #$NewDynParam.ParameterSetName = "ByParam"
        $allParams = $script:Template.parameters.Keys

        if (($allParams | Measure-Object).Count -eq 1) {
            $allParams = @(, $allParams)
        }

        if ($allParams) {
            $NewDynParam.ValidateSet = $allParams
        }
        else {
            $NewDynParam.ValidateSet = @("empty", "box")
        }

        New-DynamicParam @NewDynParam

        #$Dictionary | ConvertTo-Json | out-file -FilePath c:\temp\dyn.json -Encoding utf8 -Append
        
        $Dictionary
    }

    Begin {
        $f = $MyInvocation.InvocationName
        throw "$f is not implemented"
    }

    Process {

        $var = $PSBoundParameters.Variable
        $param = $PSBoundParameters.Parameter
    
        $hashKeyIndex = [ordered]@{}
        $index = 0
        foreach ($key in $PSBoundParameters.Keys) {
            $hashKeyIndex.Add($key, $index)
            $index++
        }

        if ($ConCat) {
            $ConcatValue = "[concat('"
            if ($Values) {
                return "$ConcatValue$($Values -join "','")))]"
            }

            if ($var -and $param) {
                $ConcatValue = "[concat("
                $varValue = "variable('$var')"
                $paramValue = "parameter('$param')"

                $paramIndex = $hashKeyIndex.Parameter
                $varIndex = $hashKeyIndex.Variable

                if ($paramIndex -lt $varIndex) {
                    return "$ConcatValue" + "$paramValue," + "$varValue" + ")]"
                }

                if ($varIndex -lt $paramIndex) {
                    return "$ConcatValue" + "$varValue," + "$paramValue" + "')]"
                }
            }
        }
    }
}