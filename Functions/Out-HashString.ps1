function Out-HashString {
    <#
.SYNOPSIS
    Convert an hashtable or and OrderedDictionary to a string

.DESCRIPTION
    Convert an hashtable or and OrderedDictionary to a string

.PARAMETER InputObject
    The object that is to be converted

.PARAMETER PreSpacing
    Number of spaces used for indentation

.EXAMPLE
    $hashObject = @{
        Name = "Tore"
        Goal = "Rule the World"
    }
    $hashObject | Out-HashString

    This will convert the hashtable to the following string
    @{
        Name = "Tore"
        Goal = "Rule the World"
    }

.INPUTS
    Hashtable

.OUTPUTS
    string
    
.NOTES
    Author:  Tore Groneng
    Website: www.firstpoint.no
    Twitter: @ToreGroneng
#>
    [cmdletbinding()]
    [OutputType([string])]
    Param(
        [Parameter(ValueFromPipeLine)]
        $InputObject
        ,
        [string]$PreSpacing = "    "
    )
    Begin {
        $f = $MyInvocation.InvocationName
        Write-Verbose -Message "$f - START"
        $newLine = [environment]::NewLine

        if ($PreSpacing) {
            $endspaceCount = $PreSpacing.Length - 4
            if ($endspaceCount -lt 0) {$endspaceCount = 0}
            $endspace = " " * $endspaceCount
        }   
    }
    Process {
        $out = "@{"
    
        $out = $out + $newLine

        if (-not $InputObject -or $InputObject.keys.count -eq 0) {return "@{}"}

        foreach ($key in $InputObject.Keys) {
            Write-Verbose -Message "$f -  Processing key [$key]"

            if ($key.Contains('$')) {
                $DisplayKey = "'$key'"
            }

            $value = $InputObject.$key
            $objType = $value.GetType().Name
            Write-Verbose -Message "$f -  ObjectType = $objType"
        
            $mode = "stringValue"

            if ($objType -eq "Hashtable" -or $objType -eq "OrderedDictionary") {
                $mode = "hashtable"
            }
        
            if ($value -is [array]) {
                if ($value[0]) {
                    $arrayType = $value[0].GetType().Name
                    Write-Verbose -Message "$f -  arrayType is [$arrayType]"
                
                    if ($arrayType -eq "Hashtable" -or $arrayType -eq "OrderedDictionary") {
                        $mode = "HashTableValue"
                    }
                    else {
                        $mode = "ArrayValue"
                    }
                }            
            }
        
            Write-Verbose -Message "$f -  Mode is [$mode]"
            if ($DisplayKey) {
                $key = $DisplayKey
                $DisplayKey = $null
            }

            $out += "$PreSpacing$key = "
        
            switch ($mode) {
                'stringValue' {
                    $out += '"' + $value + '"' + $newLine 
                }

                'hashtable' {               
                    $stringValue = Out-HashString -InputObject $value -PreSpacing "$PreSpacing    "
                    $out += $stringValue + $newLine
                }

                'HashTableValue' {
                    $stringValue = ""
                    foreach ($arrayHash in $value) {                                       
                        $hashString = Out-HashString -InputObject $arrayHash -PreSpacing "$PreSpacing    "
                        $hash = "    $hashString"
                        $hash = "$hash," + $newLine
                        $stringValue += $hash
                    }
                    $separatorIndex = $stringValue.LastIndexOf(",")
                    $stringValue = $stringValue.Remove($separatorIndex, 1)                
                    $out += $stringValue
                }

                'ArrayValue' {
                    $out += '"' + ($value -join '","') + '"' + $newLine
                }
            
                Default {}
            }
        }
        $out += "$endspace}"
        $out          
    }
}