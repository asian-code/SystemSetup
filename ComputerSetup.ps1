PowerShell -NoProfile -ExecutionPolicy Unrestricted -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Unrestricted -File ""$MyInvocation.MyCommand.Definition""' -Verb RunAs}";


Write-Host "Welcome to I-payout system setup" -ForegroundColor Green
Write-Host "by Eric (The best IT guy) Version 1.2`n" -ForegroundColor Green
# Main menu
$option=Read-Host "Options:`n[1] Desktop`n[2] Labtop`nSelect what type of device to setup" 
#Requires -RunAsAdministrator
################ Process for both systems ##############
#System update
start ms-settings:windowsupdate
Write-Host "[*] Run Windows-Update in the background" -ForegroundColor Blue -BackgroundColor White
Start-Sleep -Seconds 1

#rename system 
$name= Read-Host -Prompt "[*] Set new hostname" 
Write-Host "[*] Login to local Admin account to change name"
Start-Sleep -Seconds 1
Rename-Computer  -NewName $name -LocalCredential Admin -Force

#Activate default local admin account
Write-Host "[+] Activating local Administrator account" -ForegroundColor Green
net user Administrator ipsFL540!0
net user Administrator /active:yes

#install apps from toInstall folder
$currentDir=[string](pwd)
$files = Get-ChildItem ($currentDir + "\toInstall\")
for ($i=0; $i -lt $files.Count; $i++) {
$cFile=$files[$i].FullName #store full file path
Start-Process -FilePath $cFile #not silent bc Office365 has its own arguments
Write-Host ("[+] Running Installer " + $cFile) -ForegroundColor Green
}
########################################################

#################### Desktop setup #####################
if($option -eq "1"){
#Set DNS
Get-NetIPInterface | Format-Table
$inface= Read-Host -Prompt "`n`n[*] Select the network interface index (ifindex)" 
set-DnsClientServerAddress -InterfaceIndex $inface -ServerAddresses ("10.10.10.10","10.10.10.11")
Write-Host "[+] DNS setup complete" -ForegroundColor Green

#install apps from DesktopToInstall folder
$currentDir=[string](pwd)
$files = Get-ChildItem ($currentDir + "\DesktopToInstall\")
for ($i=0; $i -lt $files.Count; $i++) {
$cFile=$files[$i].FullName #store full file path
Start-Process -FilePath $cFile -ArgumentList "/S" #no waiting
Write-Host ("[+] Running Installer " + $cFile) -ForegroundColor Green
}

#Note to user
Write-Host "    [!] Part 1 of setup COMPLETE, please run connectDomain.ps1 after reboot" -ForegroundColor Blue -BackgroundColor White
}else{
#################### Labtop setup #####################

#install apps from LabtopToInstall folder
$currentDir=[string](pwd)
$files = Get-ChildItem ($currentDir + "\LabtopToInstall\")
for ($i=0; $i -lt $files.Count; $i++) {
$cFile=$files[$i].FullName #store full file path
Start-Process -FilePath $cFile -ArgumentList "/S" #no waiting
Write-Host ("[+] Running Installer " + $cFile) -ForegroundColor Green
}
}
Write-Host "`n[!] Wait for System-update and apps to finish installing and then reboot system" -ForegroundColor Blue -BackgroundColor White

