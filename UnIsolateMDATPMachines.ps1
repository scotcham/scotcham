# Author - ScottC
# Date - 10/9/2020
# Version - 1.2
# RUN AT YOUR OWN RISK

# This script will offboard/isolate/unisolate machines 
# depending on which URI used in the invoke REST method
# Example:  https://api-us.securitycenter.windows.com/api/machines/$machine/<offboard,isolate,unisolate>
# in MDATP using the MDATP API

$tenantId = '<tenant ID>' ### Paste your own tenant ID here
$appId = '<app ID>' ### Paste your own app ID here
$appSecret = '<app Secret>' ### Paste your own app keys here
$resourceAppIdUri = 'https://api.securitycenter.windows.com'
$oAuthUri = "https://login.windows.net/$TenantId/oauth2/token"

$authBody = [Ordered] @{
    resource = "$resourceAppIdUri"
    client_id = "$appId"
    client_secret = "$appSecret"
    grant_type = 'client_credentials'
}

$gett=Invoke-WebRequest -Uri https://login.windows.net/$tenantId/oauth2/token -Method POST -Body $authBody
$gett=($gett.Content | ConvertFrom-Json)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$contentType = "application/json"
$token=$gett.access_token
$header = @{"Authorization"="Bearer $token"}

$machineList = Get-Content C:\temp\MachineList.txt #######  Paste in the location of a list of machines

$json = @{'Comment' = 'Un Isolate Machines using a list of machines'} | ConvertTo-Json

foreach($machine in $machineList)
{
    $machine    
    $answer = Invoke-RestMethod -Headers $header -Uri  https://api-us.securitycenter.windows.com/api/machines/$machine/unisolate -Method POST -Body $json -ContentType $contentType
}
