$f = Get-Content .\2025\Day5\1.1.txt

$RANGES = @{}

foreach ($line in $f) {
  if(-not $line) {
    break
  }
  if ($line -and $line.Contains('-')) {
    $start, $end = $line.Split('-')
    $start = [UInt64]$start
    $end   = [UInt64]$end
    if ($RANGES[$start]) {
      $RANGES[$start] = [Math]::Max($end, $RANGES[$start])
    }
    else {
      $RANGES[$start] = $end
    }
  }
}

$totalFresh = 0
if ($RANGES.Keys.Count) {
  $keys = @($RANGES.Keys | Sort-Object)
  $min = $null
  $max = $null
  foreach ($key in $keys) {
    if ($null -eq $min) {
      $min = $key
      $max = $RANGES[$key]
      continue
    }
    if ($max -ge $key-1) { # ranges 1-2 and 3-4 should be joined, as these are only integers
      Write-Host 'merging' $min $max 'with' $key $RANGES[$key]
      $max = [Math]::Max($max, $RANGES[$key])
      continue
    }
    $freshInRange = $max - $min + 1
    Write-Host 'fresh in'  $min $max $freshInRange
    $totalFresh += $freshInRange
    $min = $key
    $max = $RANGES[$key]
  }
  $freshInRange = $max - $min + 1
  Write-Host 'fresh in'  $min $max $freshInRange
  $totalFresh += $freshInRange
}

Write-Host 'Part 2:' $totalFresh