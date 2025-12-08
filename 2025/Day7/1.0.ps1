Measure-Command {
  $f = Get-Content .\2025\Day7\1.1.txt

  $maxY = $f[0].Length - 1
  $splits = 0
  $beams = @{}

  $y = 0
  while ($f[0][$y] -ne 'S' -and $y -lt $maxY) {
  $y++
  }
  $beams[$y] = 1

  foreach ($line in $f) {
    for ($y = 1; $y -lt $maxY; $y++) {
      if ($line[$y] -eq '^' -and $beams[$y] -gt 0) {
        $splits++
        $beams[$y-1] += $beams[$y]
        $beams[$y+1] += $beams[$y]
        $beams[$y] = 0
      }
    }
  }

  Write-Host "Part 1:" $splits
  Write-Host "Part 2:" ($beams.Values | Measure-Object -Sum).Sum
}