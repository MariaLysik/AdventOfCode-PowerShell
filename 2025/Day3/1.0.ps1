$totalJoltage = 0
$CACHE = @{}

function Get-MaxJoltage([string]$bank) {
  if ($CACHE[$bank]) {
    return $CACHE[$bank]
  }
  $arr = $bank.ToCharArray()
  $firstPointer = 0
  $secondPointer = 1
  for ($i = 1; $i -le $arr.Length-2; $i++) {
    if($arr[$i] -gt $arr[$firstPointer]) {
      $firstPointer = $i
      $secondPointer = $i+1
    }
    if($secondPointer -lt $i -and $arr[$i] -gt $arr[$secondPointer]) {
      $secondPointer = $i
    }
  }
  if($secondPointer -lt $arr.Length-1 -and $arr[$arr.Length-1] -gt $arr[$secondPointer]) {
    $secondPointer = $arr.Length-1
  }
  $joltage = $arr[$firstPointer] + $arr[$secondPointer]
  $CACHE[$bank] = $joltage
  return $joltage
}

Get-Content .\2025\Day3\1.1.txt | ForEach-Object {
  $totalJoltage += [int](Get-MaxJoltage $_)
}

Write-Host 'Part 1:' $totalJoltage