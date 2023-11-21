# Distributed Systems Traffic Limiter Tools

## Contents
- [Quick Start](#quick-start)
- [Setting Upload Limits](#setting-upload-limit)
    - [Usage](#usage)
    - [Example for One Program](#example-limiting-speedtestexe-to-1-mbps)
    - [Example for All Programs](#example-limiting-all-programs-to-100-kbps)
- [Removing Limits](#clearing-network-limits)
    - [Usage](#usage-1)
- [Checking Active Limits](#checking-active-policies)
    - [Usage](#usage-2)


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

**Note:** The ApplicationName parameter is optional. Not specifying a value will limit the upload rate of the entire system.

### Usage

```
.\create-upload-limit -ApplicationName <name-of-application> -Bps <bits-per-second-limit>
```

### Example: Limiting Speedtest.exe to 1 Mbps

To limit the (upload) speed of Ookla's speedtest software to 1Mbps, you can run:
```
.\create-upload-limit.ps1 -ApplicationName speedtest.exe -Bps 1000000
```

### Example: Limiting all programs to 100 Kbps
To limit all programs running on the machine to a *combined* 100 Kbps, you can run:
```
.\create-upload-limit.ps1 -ApplicationName speedtest.exe -Bps 100000
```

## Clearing Network Limits

To clear all policies that have been applied, use the [remove-policies.ps1](/PowerShell%20Scripts/remove-policies.ps1) script.

### Usage
```
.\remove-policies.ps1
```

## Checking Active Policies

You can view all active policies using [list-policies.ps1](/PowerShell%20Scripts/list-policies.ps1). Note that applied policies are stored in the windows `ActiveStore` Policy Store, meaning that they do not persist through system reboots.

### Usage
```
.\list-policies.ps1
```