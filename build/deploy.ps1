$rgname = 'datafactorydev'
$templatefile = '.\ArmTemplate\ARMTemplateForFactory.json'
$parameters = '@.\dev-adfutils.parameters.json'
$deploymentname = $('ExampleDeployment_'+$(Get-Date).tostring("yyyyMMdd.HHmmss"))
$subscriptionname = 'Azure MSDN 01'


echo $('switch subscription to ' + $subscriptionname)
az account set --subscription $subscriptionname
az account list --output table

echo $('create deployment '  + $deploymentname + ', in rg: ' + $rgname)
az deployment group create --name $deploymentname --resource-group $rgname --template-file $templatefile --parameters $parameters

