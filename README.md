# Distributed Systems Traffic Limiter Tools

## Quick Start

To run these scripts, you'll need to enable PowerShell script execution on your machine, or manually bypass the restricted execution policy when running the scripts.

If you want to change the script execution policy, open PowerShell as administrator and run the command below. This opens you up to any scripts being run and has security implications.
```ps1
Set-ExecutionPolicy Unrestricted
```

If you instead prefer to keep your policy settings, you can run the scripts as follows from a shell:

```
powershell.exe -executionpolicy bypass <path-to-script>
```

## Setting Upload Limit

You can limit the ***upload*** bandwidth of a specific application by using the [create-upload-limit.ps1](/PowerShell%20Scripts/create-upload-limit.ps1) script. The script will cap the upload rate of the script to a specified value. The script can be run multiple times to impose several caps on different apps concurrently.

### Usage

```
.\create-upload-limit -ApplicationName <name-of-application> -Bps <bits-per-second-limit>
```

**Note:** The ApplicationName parameter is optional. Not specifying a value will limit the upload rate of the entire system.

## Clearing Network Limits

To clear all policies that have been applied, use the [remove-policies.ps1](/PowerShell%20Scripts/remove-policies.ps1) script.

### Usage
```
.\remove-policies.ps1
```