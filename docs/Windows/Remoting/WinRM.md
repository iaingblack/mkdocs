# WinRM Setup

## WinRM Over HTTPS

### Generate a Certificate on Remote Server

Requires makecert utility from Windows SDK kits. Copy to c:\windows\system32. From a cmd prompt
```
winrm quickconfig -transport:https
mkdir c:\cert
cd c:\cert
makecert -pe -n CN=RecoveryTestRootCA -ss root -sr LocalMachine -sky signature -r RecoveryTestRootCA.cer
makecert.exe -pe -n CN=PutInYourComputerName -ss my -sr LocalMachine -sky exchange -eku 1.3.6.1.5.5.7.3.1,1.3.6.1.5.5.7.3.2 -in RecoveryTestRootCa -is root -ir LocalMachine -sp "Microsoft RSA SChannel Cryptographic Provider" -sy 12 PutInYourComputerName.cer
GET THUMBPRINT via MMC - ‎ie 59EA0A1D1C4E4A6A6E0E2A6B6F8D6C1E8DD67E32
winrm create winrm/config/listener?Address=IP:0.0.0.0+Transport=HTTPS @{Hostname="CRTG-en";CertificateThumbprint="59EA0A1D1C4E4A6A6E0E2A6B6F8D6C1E8DD67E32";Port="443"}
```

On client run something like this;

```
$username = "user"         
$password = "Password1"
$securepassword = ConvertTo-SecureString $password -AsPlainText -force             
$cred = New-Object -typename System.Management.Automation.PSCredential -ArgumentList $username, $securepassword
$sessionOption = New-PSSessionOption -OutputBufferingMode Drop -IdleTimeout (3600000*5) -SkipCACheck –SkipCNCheck -SkipRevocationCheck

Invoke-Command -ConnectionURI https://mymachine:443 -ScriptBlock { Get-ChildItem C:\ } -credential $cred -SessionOption $sessionOption
```
