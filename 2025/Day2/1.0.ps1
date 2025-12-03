$sumOfInvalidIds = 0

function Is-Invalid([string]$number) {
  if ($number.Length -band 1) { # check if odd number
    return $false
  }
  $halfDigits = $number.Length / 2
  return $number.substring(0,$halfDigits) -eq $number.substring($halfDigits)
}

$ranges = (Get-Content .\2025\Day2\1.0.txt) -split ','
$ranges | ForEach-Object {
  Write-Host $_
  $min, $max = $_ -split '-'
  $minDigits = $min.Length
  $maxDigits = $max.Length
  if ($minDigits -eq $maxDigits -and $minDigits%2) {
    Write-Host 'min and max has the same and odd number of digits, skipping'
    return
  }
  for ($i = [uint64]$min; $i -le [uint64]$max; $i++) {
    if (Is-Invalid "$i") {
      Write-Host 'found invalid' $i
      $sumOfInvalidIds += $i
    }
  }
}

Write-Host 'part 1:' $sumOfInvalidIds