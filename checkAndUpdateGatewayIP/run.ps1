# Input bindings are passed in via param block.
param($Timer)

# Get the current universal time in the default string format
$currentUTCtime = (Get-Date).ToUniversalTime()

# The 'IsPastDue' porperty is 'true' when the current function invocation is later than scheduled.
if ($Timer.IsPastDue) {
    Write-Host "PowerShell timer is running late!"
}
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
    #$gw.GatewayIpAddress = $dynDnsIpAddress
    #set-azLocalNetworkGateway -LocalNetworkGateway $gw
}
# Write an information log with the current time.
Write-Host "PowerShell timer trigger function ran! TIME: $currentUTCtime"
