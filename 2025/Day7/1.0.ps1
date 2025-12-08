Measure-Command {
  $f = Get-Content .\2025\Day7\1.1.txt

  $splits = 0
  $activePaths = @{}

  $y = 0
  while ($f[0][$y] -ne 'S' -and $y -lt $f[0].Length - 1) { $y++ }
  $activePaths[$y] = 1

  for ($x = 1; $x -lt $f.Length -1; $x++) {
    foreach ($y in @($activePaths.Keys)) {
      if ($f[$x][$y] -eq '^') {
        $splits++
        $activePaths[$y-1] += $activePaths[$y]
        $activePaths[$y+1] += $activePaths[$y]
        $activePaths.Remove($y)
      }
    }
  }

  Write-Host "Part 1:" $splits
  Write-Host "Part 2:" ($activePaths.Values | Measure-Object -Sum).Sum
}