$sumOfInvalidIds = 0

function Is-Invalid([string]$number) {
  $length = $number.Length
  if ($length -le 1) {
    return $false
  }
  if ($number -match "^(.)\1*$") {
    return $true
  }
  # check could be narrowed down to prime dividers only (could be store in a cache, to avoid re-calculating them)
  for ($i = 2; $i -le $length / 2; $i++) {
    if ($length % $i -ne 0) {
      #Write-Host 'length' $length 'not a multiplication of' $i '> skipping'
      continue
    }
    $chunkSize = $length / $i
    $expectedPattern = $number.substring(0, $chunkSize)
    #Write-Host 'chunk size' $chunkSize 'expected pattern' $expectedPattern
    $found = $true
    for ($j = 1; $j -lt $i; $j++) {
      if ($number.substring($j * $chunkSize, $chunkSize) -ne $expectedPattern) {
        $found = $false
        break
      }
    }
    if ($found) {
      return $true
    }
  }
  return $false
}

$ranges = (Get-Content .\2025\Day2\1.0.txt) -split ','
$ranges | ForEach-Object {
  #Write-Host $_
  $min, $max = $_ -split '-'
  for ($i = [uint64]$min; $i -le [uint64]$max; $i++) {
    if ("$i" -match '^([1-9][0-9]*)\1+$') {
      #Write-Host 'found invalid' $i
      $sumOfInvalidIds += $i
    }
  }
}

Write-Host 'part 2:' $sumOfInvalidIds