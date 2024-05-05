locals {
  user_data_dns_server = <<EOT
<powershell>
# install DNS with admin tools
Install-WindowsFeature DNS -IncludeManagementTools

# Set Conditional Forwarder
Add-DnsServerConditionalForwarderZone -Name "master.aws" -MasterServers 10.1.2.10,10.1.3.10 -PassThru

# Add Forward lookup Zone
Add-DnsServerPrimaryZone -Name "master.local" -ZoneFile "master.local" -DynamicUpdate None -PassThru

# Add A record
Add-DnsServerResourceRecordA -Name "test" -ZoneName "master.local" -IPv4Address "10.2.2.200" -TimeToLive 01:00:00 -PassThru 
</powershell>
<persist>true</persist>
EOT

  user_data_dns_client = <<EOT
<powershell>
$dnsServers = @("10.2.2.100", "10.2.0.2")

$client = Get-NetIPAddress |
    Where-Object { $_.IPAddress -eq (Invoke-RestMethod http://169.254.169.254/latest/meta-data/local-ipv4) } |
    Get-DnsClient

$client | Set-DnsClientServerAddress -ServerAddresses $dnsServers
</powershell>
<persist>true</persist>
EOT
}
