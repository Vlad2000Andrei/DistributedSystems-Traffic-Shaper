param($Bps, $ApplicationName)

$policyName = "Limit $ApplicationName $Bps bps"

if ($PSBoundParameters.ContainsKey('ApplicationName')) {
    New-NetQosPolicy -Name $policyName -AppPathNameMatchCondition $ApplicationName -ThrottleRateActionBitsPerSecond $Bps -PolicyStore ActiveStore
}
else {
    New-NetQosPolicy -Name $policyName -ThrottleRateActionBitsPerSecond $Bps -PolicyStore ActiveStore
}
