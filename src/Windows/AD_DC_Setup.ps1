# Define Variables
$DomainName = "g07-syndus.internal"  # Domain name
$NetBiosName = "G07SYNDUS"       # NetBIOS name (must be uppercase)
$SafeModeAdminPassword = ConvertTo-SecureString "Admin" -AsPlainText -Force
$IPAddress = "192.168.207.049"
$SubnetMask = "255.255.255.248"
$Gateway = "192.168.207.1"
$DNS = $IPAddress

# Ensure script runs with admin privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator!" -ForegroundColor Red
    exit
}

# Install the AD DS Role
Write-Host "Installing Active Directory Domain Services..." -ForegroundColor Cyan
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

# Configure Static IP (Required for DC)
Write-Host "Configuring Static IP Address..." -ForegroundColor Cyan
$Interface = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
New-NetIPAddress -InterfaceIndex $Interface.ifIndex -IPAddress $IPAddress -PrefixLength 24 -DefaultGateway $Gateway
Set-DnsClientServerAddress -InterfaceIndex $Interface.ifIndex -ServerAddresses $DNS

# Promote the Server to a Domain Controller
Write-Host "Configuring Domain Controller: $DomainName" -ForegroundColor Cyan
Install-ADDSForest `
    -DomainName $DomainName `
    -DomainNetbiosName $NetBiosName `
    -SafeModeAdministratorPassword $SafeModeAdminPassword `
    -Force

# Notify User
Write-Host "Domain Controller setup complete. The system will restart in 10 seconds..." -ForegroundColor Green
Start-Sleep -Seconds 10
Restart-Computer -Force
