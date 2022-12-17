# Show what is installed
$instances = $openinstancekey.getvaluenames();
foreach ($instance in $instances) {
    $instancename = $openinstancekey.getvalue($instance);
    $instancesetupkey = "SOFTWARE\Microsoft\Microsoft SQL Server\" + $instancename + "\Setup"; 
    $openinstancesetupkey = $regconnection.opensubkey($instancesetupkey);
    $edition = $openinstancesetupkey.getvalue("Edition")
    $version = $openinstancesetupkey.getvalue("Version");
    switch -wildcard ($version) {
        "12*" {$versionname = "SQL Server 2014";}
        "11*" {$versionname = "SQL Server 2012";}
        "10.5*" {$versionname = "SQL Server 2008 R2";}
        "10.*" {$versionname = "SQL Server 2008";}
        default {$versionname = $version;}
    }
    Write-Host "SQL Installed. Details are below"
    Write-Host "--------------------------------"
    Write-Host "INSTANCE - $instancename"
    Write-Host "EDITION  - $edition" 
    Write-Host "VERSION  - $versionname" 
}