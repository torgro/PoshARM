@{
    Severity = @('Error', 'Warning')

    # Example explicit inclusions or exclusions
     
    # IncludeRules = @('PSAvoidDefaultValueSwitchParameter',
    #                 'PSMissingModuleManifestField',
    #                 'PSReservedCmdletChar',
    #                 'PSReservedParams',
    #                 'PSShouldProcess',
    #                 'PSUseApprovedVerbs',
    #                 'PSUseDeclaredVarsMoreThanAssigments')

    # ExcludeRules = @('PSAvoidUsingWriteHost', 'PSAvoidGlobalVars')

    Rules = @{
        PSPlaceOpenBrace = @{
            Enable = $true
            OnSameLine = $true
            NewLineAfter = $true
        }

        PSPlaceCloseBrace = @{
            Enable = $false
        }

        PSUseConsistentIndentation = @{
            Enable = $true
            IndentationSize = 4
        }

        PSUseWhitespace = @{
            Enable = $true
            CheckOpenBrace = $true
            CheckOpenParen = $true
            CheckOperator = $true
            CheckSeparator = $true
        }
    }
}
