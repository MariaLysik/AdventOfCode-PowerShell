$f = Get-Content .\2025\Day7\1.0.txt

$maxY = $f[0].Length - 1
$splits = 0
$beams = @()
0..$maxY | ForEach-Object {
  if ($f[0][$_] -eq 'S') {
    $beams += 1 
  }
  else {
    $beams += 0
  }
}

foreach ($line in $f) {
  for ($i = 0; $i -lt $maxY; $i++) {
    if ($line[$i] -eq '^' -and $beams[$i] -gt 0) {
      $splits++
      $beams[$i-1] += $beams[$i]
      $beams[$i+1] += $beams[$i]
      $beams[$i] = 0
    }
  }
}

Write-Host "Part 1:" $splits
Write-Host "Part 2:" ($beams | Measure-Object -Sum).Sum