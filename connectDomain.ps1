#Requires -RunAsAdministrator


#Connect to domain
#Write-Host "[*] Checking if connected to ips.local domain..."
#if not connected to domain: do something
Write-Host "Welcome to I-payout system setup part2 for Desktops" -ForegroundColor Green
Write-Host "by Eric (The best IT guy)`n" -ForegroundColor Green
Write-Host "[*] Setting Domain to ips.local"-ForegroundColor Blue
#$Cdomain=systeminfo | findstr "Domain"

add-computer -domainname "ips.local" -restart
Write-Host "[!] Updated domain, requires restart to apply changes"
