# .Net 3.5

## Command

To install, you need the 'microsoft-windows-netfx3-ondemand-package.cab ' file from the DVD. Either run command below with file or mount DVD prior to install.

```
mkdir c:\sources\sxs &&
move microsoft-windows-netfx3-ondemand-package.cab c:\sources\sxs\
dism /online /enable-feature /featurename:NetFx3 /All /Source:C:\sources\sxs /quiet
```

### Server 2012R2
[ ISO Link](http://care.dlservice.microsoft.com/dl/download/6/2/A/62A76ABB-9990-4EFC-A4FE-C7D698DAEB96/9600.17050.WINBLUE_REFRESH.140317-1640_X64FRE_SERVER_EVAL_EN-US-IR3_SSS_X64FREE_EN-US_DV9.ISO)

### Server 2016
[ISO Link](http://care.dlservice.microsoft.com/dl/download/1/6/F/16FA20E6-4662-482A-920B-1A45CF5AAE3C/14393.0.160715-1616.RS1_RELEASE_SERVER_EVAL_X64FRE_EN-US.ISO)
