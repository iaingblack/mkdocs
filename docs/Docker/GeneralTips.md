# General Docker Tips

## General

### Starting a container for testing
To start a container and just use it for testing, run something like this;

```
docker run -i -t ubuntu:12.04 /bin/bash
```

## HouseKeeping

### Windows
To remove older containers not needed, run this.

### Stop All Containers
```
docker ps -a -q | %{docker stop $_}
```

#### Remove All Containers
```
docker ps -a -q | %{docker rm -f $_}
```

#### Remove Dangling Images
```
docker images --filter dangling=true -q | %{docker rmi -f $_}
```

#### All in One
```
#CLEAN.BAT
powershell -command Y:\commands\clean.ps1

#CLEAN.PS1
$folder = Split-Path -Path $MyInvocation.MyCommand.Path
Write-Host "Stopping Containers"
$script = $folder + "\stop-all-containers.ps1"
& $script 
Write-Host "Removing Containers"
$script = $folder + "\remove-all-containers.ps1"
& $script 
Write-Host "Deleting Images"
$script = $folder + "\remove-dangling-images.ps1"
& $script 
```

## Config

### Reduce Download Threads

Note the concurrent lines.

```
{
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB",
      "enabled": true
    }
  },
  "experimental": false,
  "features": {
    "buildkit": true
  },
  "max-concurrent-downloads": 1,
  "max-concurrent-uploads": 1
}
```
