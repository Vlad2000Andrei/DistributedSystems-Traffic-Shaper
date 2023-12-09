# Distributed Systems Traffic Limiter Tools

## Contents
- [Using PowerShell Scripts for Quality of Service (QoS) Policies](#using-powershell-scripts-for-quality-of-service-qos-policies)
    - [Quick Start](#quick-start)
    - [Setting Upload Limits](#setting-upload-limit)
        - [Usage](#usage)
        - [Example for One Program](#example-limiting-speedtestexe-to-1-mbps)
        - [Example for All Programs](#example-limiting-all-programs-to-100-kbps)
    - [Removing Limits](#clearing-network-limits)
        - [Usage](#usage-1)
    - [Checking Active Limits](#checking-active-policies)
        - [Usage](#usage-2)
- [Using Clumsy.exe Scripts](#using-clumsy)
    - [Quick Start](#quick-start-1)
        - [PowerShell Scripts](#powershell-scripts)
        - [Clumsy.exe](#clumsyexe)
    - [General Arguments](#general-arguments)
        - [ClumsyPath](#clumsypath)
        - [AffectUpload](#affectupload)
        - [AffectDownload](#affectdownload)
    - [Setting Bandwidth Limit](#setting-a-bandwidth-limit)
        - [Example: 1MB/s Limit](#example-limiting-bandwidth-to-1mbs)
    - [Setting a Delay](#setting-a-delay)
        - [Example: Delay Inbound and Outbound by 5ms with 50% chance](#example-delaying-incoming-and-outgoing-packets-by-5ms-with-a-50-chance)
        - [Exmaple: Delay All Outgoing Packets by 30ms](#example-delaying-all-outgoing-packets-by-30ms)
    - [Setting a Drop Chance](#setting-a-drop-chance)
        - [Example: Dropping 25% of Outgoing Packets](#example-dropping-25-of-outgoing-packets)
        - [Example: Dropping 5% of All Packets](#example-dropping-5-of-all-packets)
    - [Stopping Clumsy](#stopping-clumsy)

# Using PowerShell Scripts for Quality of Service (QoS) Policies

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

# Using Clumsy

## Quick Start

### PowerShell Scripts

To use the powershell scripts that interact with clumsy, you will need to enable script running in windows. Refer back to [this README section](#quick-start) for that.

### Clumsy.exe

Clumsy is a free, open-source tool for Windows. It can be compiled from source or downloaded as an executable (which is the easier option). You can download it from [here](https://jagt.github.io/clumsy/download.html). Once downloaded, unzip it and place the files into a folder of your choice. We'll refer to this folder as the `clumsy_folder` in the remainder of this README.

## General Arguments

The provided `start-clumsy.ps1` script supports several arguments. Some are targeted at [bandwidth throttling](#setting-a-bandwidth-limit), [packet delays](#setting-a-delay), and [packet drop chance](#setting-a-drop-chance), while others are general.

### ClumsyPath
The argument is provided as:

```ps1
./start-clumsy.ps1 -ClumsyPath "<path to clumsy_folder>"
```

It tells the script where it can find the directory containing the `clumsy.exe` executable which you downloaded [previously](#clumsyexe).

### AffectUpload

The argument is provided as:
```ps1
./start-clumsy.ps1 -AffectUpload $true
```
or:
```ps1
./start-clumsy.ps1 -AffectUpload $false
```

It decides whether [packet delays](#setting-a-delay) and [packet drop chance](#setting-a-drop-chance) affect outgoing traffic or not.

> ***NOTE***: Bandwidth limits set with clumsy are not affected by this (for the reasoning, ask the clumsy devs not me).

### AffectDownload

The argument is provided as:
```ps1
./start-clumsy.ps1 -AffectDownload $true
```
or:
```ps1
./start-clumsy.ps1 -AffectDownload $false
```

It decides whether [packet delays](#setting-a-delay) and [packet drop chance](#setting-a-drop-chance) affect incoming traffic or not.

> ***NOTE***: Bandwidth limits set with clumsy are not affected by this (for the reasoning, ask the clumsy devs not me).

## Setting a Bandwidth Limit

Clumsy does support limiting the bandwidth but, anecdotally, is bad at doing it. To limit the bandwidth, we recommend using the [PowerShell QoS Option](#using-powershell-scripts-for-quality-of-service-qos-policies). However, for the sake of completeness, the wrapper script supports it.

The bandwidth limit is symmetric and not affected by the `-AffectUpload` or `-AffectDownload` arguments. 

A bandiwdth cap can be specified in KB/s:

```ps1
./start-clumsy.ps1 -ClumsyPath "<path to clumsy_folder>" -BandwidthKBps <Limit>
```
> Note: The `Limit` argument must be an integer. This is enforced by PowerShell.

### Example: Limiting Bandwidth to 1MB/s
```ps1
./start-clumsy.ps1 -ClumsyPath "C:\Program Files\Clumsy\" -BandwidthKBps 5000
```

## Setting a Delay

Clumsy supports delaying packets with a random `DelayChance` and a set time `Delay` in milliseconds. These are both specified as arguments:

```ps1
./start-clumsy.ps1 -ClumsyPath "<path to clumsy_folder>" -Delay <Delay> -DelayChance <DelayChance>
```

> Note: The `Delay` argument must be an integer number of *miliseconds*.

> Note: The `DelayChance` argument must be a floating point number between 0 and 1. The powershell script will convert it into a number between 0 and 100 for clumsy. Up to 4 decimal positions are supported in your input, further ones will be rounded away.

### Example: Delaying Incoming and Outgoing Packets by 5ms with a 50% chance.

```ps1
./start-clumsy.ps1 -ClumsyPath "C:\Program Files\Clumsy\" -Delay 5 -DelayChance 0.5 -AffectUpload $true -AffectDownload $true
```

### Example: Delaying ALL Outgoing Packets by 30ms.

```ps1
./start-clumsy.ps1 -ClumsyPath "C:\Program Files\Clumsy\" -Delay 30 -DelayChance 1.0 -AffectUpload $true
```

## Setting a Drop Chance

Clumsy supports randomly dropping packets with a given `DropChance`. This can be specified as an argument:

```ps1
./start-clumsy.ps1 -ClumsyPath "<path to clumsy_folder>" -DropChance <DropChance>
```

> Note: The `DropChance` must be a floating point number between 0 and 1. The powershell script will convert it into a number between 0 and 100 for clumsy. Up to 4 decimal positions are supported in your input, further ones will be rounded away.

### Example: Dropping 25% of Outgoing Packets

```ps1
./start-clumsy.ps1 -ClumsyPath "C:\Program Files\Clumsy\" -DropChance 0.25 -AffectUpload $true
```

### Example: Dropping 5% of All Packets

```ps1
./start-clumsy.ps1 -ClumsyPath "C:\Program Files\Clumsy\" -DropChance 0.05 -AffectUpload $true -AffectDownload $true
```

## Stopping Clumsy

You can stop a running clumsy process using the `stop-clumsy.ps1` script:
```ps1
./stop-clumsy.ps1
```
> Note: If clumsy is not running, this script is a No-Op, nothing will happen.
