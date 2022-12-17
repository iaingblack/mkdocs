# Environment Setup

## General Handy Tricks

### How to Reload the PATH
Run this. Done!

```
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
```