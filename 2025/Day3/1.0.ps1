$CACHE = @{}

function Get-MaxJoltage([string]$bank,[int]$batteryCount) {
  if ($batteryCount -le 0) {
    return ""
  }
  $cacheKey = "$batteryCount" + ":" + $bank
  if ($CACHE.ContainsKey($cacheKey)) {
    return $CACHE[$cacheKey]
  }
  if ($bank.Length -eq $batteryCount) {
    $CACHE[$cacheKey] = $bank
    return $bank
  }
  $arr = $bank.ToCharArray()
  $pointer = 0
  for ($i = 1; $i -le $arr.Length-$batteryCount; $i++) {
    if ($arr[$pointer] -eq '9') {
      break
    }
    if ($arr[$i] -gt $arr[$pointer]) {
      $pointer = $i
    }
  }
  $joltage = $arr[$pointer] + (Get-MaxJoltage $bank.substring($pointer+1) ($batteryCount-1))
  $CACHE[$cacheKey] = $joltage
  return $joltage
}

$totalJoltage2 = 0
$totalJoltage12 = 0
Get-Content .\2025\Day3\1.0.txt | ForEach-Object {
  $totalJoltage2 += [UInt64](Get-MaxJoltage $_ 2)
  $totalJoltage12 += [UInt64](Get-MaxJoltage $_ 12)
}

Write-Host 'Part 1:' $totalJoltage2
Write-Host 'Part 2:' $totalJoltage12