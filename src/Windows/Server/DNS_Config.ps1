$DomainName = "g07-syndus.internal"
$DNSForwarders = "8.8.8.8", "8.8.4.4"
$NetworkID = "192.168.207.48"

Install-WindowsFeature -Name DNS -IncludeManagementTools
Set-DnsServerForwarder -IPAddress $DNSForwarders

# Forward Lookup Zone
Add-DnsServerPrimaryZone -Name $DomainName -ZoneFile "$DomainName.dns"

# Reverse Lookup Zone
Add-DnsServerPrimaryZone -NetworkID $NetworkID -ZoneFile "207.168.192.in-addr.arpa"

# A Record
Add-DnsServerResourceRecordA -Name "g07-syndus" -ZoneName $DomainName -IPv4Address "192.168.207.54" -CreatePtr -ErrorAction SilentlyContinue
Add-DnsServerResourceRecordA -Name "backup" -ZoneName $DomainName -IPv4Address "192.168.207.58" -CreatePtr -ErrorAction SilentlyContinue
Add-DnsServerResourceRecordA -Name "www" -ZoneName $DomainName -IPv4Address "192.168.207.18" -CreatePtr -ErrorAction SilentlyContinue
Add-DnsServerResourceRecordA -Name "nextCloud" -ZoneName $DomainName -IPv4Address "192.168.207.18" -CreatePtr -ErrorAction SilentlyContinue
Add-DnsServerResourceRecordA -Name "jellyFin" -ZoneName $DomainName -IPv4Address "192.168.207.18" -CreatePtr -ErrorAction SilentlyContinue


# CNAME Record
Add-DnsServerResourceRecordCName -Name "fileserver" -ZoneName $DomainName  -HostNameAlias "server1.$DomainName" -ErrorAction SilentlyContinue




