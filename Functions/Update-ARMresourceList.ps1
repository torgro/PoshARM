#Requires -Version 5.0
function Update-ARMresourceList
{
<#
.SYNOPSIS
    This will update the allResources.json file that is used as input when creating a New-ARMresource

.DESCRIPTION
    This will update the allResources.json file that is used as input when creating a New-ARMresource. This cmdlet supports 
    ShouldProcess (whatif).

.PARAMETER Credential
    Credentials for an Azure subscription

.PARAMETER Force
    Force an update of the file if it exists

.EXAMPLE
    Update-ARMresourceList

    This will try and fetch the resoruce provider list from Azure using the current AzureRMcontext. If no AzureRMcontext exists, it will 
    invoke Login-AzureRMAccount without credentials. 

.EXAMPLE
    Update-ARMresourceList -Credential (Get-Credential -Message "Azure Credential")

    This will try and fetch the resoruce provider list from Azure using the current AzureRMcontext. If no AzureRMcontext exists, it will 
    invoke Login-AzureRMAccount with the specified credentials. 

.INPUTS
    PSCustomObject

.OUTPUTS
    string

.NOTES
    Author:  Tore Groneng
    Website: www.firstpoint.no
    Twitter: @ToreGroneng
#>
[cmdletbinding(
    SupportsShouldProcess=$true
)]
Param(
    [pscredential]$Credential
    ,
    [switch]$Force
)
    $LoggedIn = $false
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"

    try
    {
        Write-Verbose -Message "$f - Getting AzureRMContext"
        
        Get-AzureRmContext
        $LoggedIn = $true
    }
    catch
    {
        $ex = $_.Exception
        Write-Verbose -Message "$f -  Get-AzureRmContext threw an exception, propably not loggedin"
    }

    if ($LoggedIn -eq $false)
    {
        if ($Credential)
        {
            Write-Verbose -Message "$f -  Invoking Login-AzureRmAccount with credentials"
            Login-AzureRmAccount -Credential $Credential -ErrorAction Stop
        }
        else
        {
            Write-Verbose -Message "$f -  Invoking Login-AzureRmAccount without credentials"
            Login-AzureRmAccount -ErrorAction Stop
        }
    }
    
    $fileName = Split-Path -Path $PSScriptRoot -Parent | Join-Path -ChildPath Data | Join-Path -ChildPath "allResources.json"

    $outFile = @{}
    $shouldProcessOperation = "Creating file"
    
    if ($Force.IsPresent)
    {
        $outFile.Add("Force", $true)
        $shouldProcessOperation = "Overwriting file"
    }
   
    if ($pscmdlet.ShouldProcess("$fileName", $shouldProcessOperation))
    {
        Write-Verbose -Message "$f -  Getting a providerlist, saving to [$fileName]"
        Get-AzureRmResourceProvider -ListAvailable | ConvertTo-Json -Depth 10 | Out-File -FilePath "$fileName" -Encoding utf8 @outFile
    }
    Write-Verbose -Message "$f - END"
}