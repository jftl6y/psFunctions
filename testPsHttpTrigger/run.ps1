using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
# $name = $Request.Query.Name
# if (-not $name) {
#     $name = $Request.Body.Name
# }

# if ($name) {
#     $status = [HttpStatusCode]::OK
#     $body = "Hello $name"
# }
# else {
#     $status = [HttpStatusCode]::BadRequest
#     $body = "Please pass a name on the query string or in the request body."
# }
#install-module DnsClient
#import-module DnsClient


Write-Host "Host name is $env:hostName"
#$dynDnsIpAddress = (resolve-dnsName $env:hostName).IP4Address[0]
$dynDnsIpAddress = ([System.Net.Dns]::GetHostEntry($env:hostName)).AddressList[0].IpAddressToString
write-host "Found ipAddress for $hostName - $dynDnsIpAddress"
$gw = get-azLocalNetworkGateway -resourceGroupName $env:GatewayResourceGroupName -Name $env:GatewayResourceName
$existingGwIpAddress = $gw.GatewayIpAddress
write-host "Existing Gateway Ip Address is $existingGwIpAddress"
if ($dynDnsIpAddress -ne $existingGwIpAddress)
{
    write-host ("Address mismatch-old:  $existingGwIpAddress -new: $dynDnsIpAddress")
    write-host ("Changing gateway IP to $dynDnsIpAddress")
    $gw.GatewayIpAddress = $dynDnsIpAddress
    set-azLocalNetworkGateway -LocalNetworkGateway $gw
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
# Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
#     StatusCode = $status
#     Body = $body
#})
