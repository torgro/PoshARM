function Update-ARMresourceList
{
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
            Write-Verbose -Message "$f -  Trying login with credentials"
            Login-AzureRmAccount -Credential $Credential -ErrorAction Stop
        }
        else
        {
            Write-Verbose -Message "$f -  Trying to login"
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