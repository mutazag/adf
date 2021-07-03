param
(
    [parameter(Mandatory = $true)] [String] $globalParametersFilePath,
    [parameter(Mandatory = $true)] [String] $resourceGroupName,
    [parameter(Mandatory = $true)] [String] $dataFactoryName
)

Import-Module Az.DataFactory

$newGlobalParameters = New-Object 'system.collections.generic.dictionary[string,Microsoft.Azure.Management.DataFactory.Models.GlobalParameterSpecification]'

Write-Host "Getting global parameters JSON from: " $globalParametersFilePath
$globalParametersJson = Get-Content -ErrorAction:Stop $globalParametersFilePath

Write-Host "Parsing JSON..."
$globalParametersObject = $globalParametersJson | ConvertFrom-Json
    
function Get-ObjectMember {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)]
        [PSCustomObject]$obj
    )
    $obj | Get-Member -MemberType NoteProperty | ForEach-Object {
        $key = $_.Name
        [PSCustomObject]@{Key = $key; Value = $obj."$key"}
    }
}

$globalParametersObject | Get-ObjectMember | ForEach-Object {
    Write-Host "Adding global parameter" $_.Key "of type:" $_.Value.type 
    $globalParameterValue = New-Object -TypeName Microsoft.Azure.Management.DataFactory.Models.GlobalParameterSpecification
    $globalParameterValue.Type = $_.Value.type 
    if (($globalParameterValue.Type -eq "object") -or ($globalParameterValue.Type -eq "array")) {
        $globalParameterValue.Value = ConvertTo-Json -Depth 100 -Compress $_.Value.value
    } else {
        $globalParameterValue.Value = $_.Value.value
    }
    $newGlobalParameters.Add($_.Key, $globalParameterValue)
}

$dataFactory = Get-AzDataFactoryV2 -ResourceGroupName $resourceGroupName -Name $dataFactoryName
$dataFactory.GlobalParameters = $newGlobalParameters

Write-Host "Updating" $newGlobalParameters.Count "global parameters."

Set-AzDataFactoryV2 -InputObject $dataFactory -Force