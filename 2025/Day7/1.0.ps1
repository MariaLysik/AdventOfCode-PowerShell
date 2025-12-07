$f = Get-Content .\2025\Day7\1.1.txt

$maxX = $f.Length - 1
$maxY = $f[0].Length - 1
$global:splitCount = 0
$visited = @{}

function Move-Downward([string]$coords) {
  if ($visited[$coords]) {
    return
  }
  $visited[$coords] = 1
  $x, $y = $coords -split ':'
  $x = [int]$x
  $y = [int]$y
  if ($x -lt 0 -or $x -gt $maxX -or $y -lt 0 -or $y -gt $maxY) {
    return
  }
  if ($f[$x][$y] -eq '^') {
    $global:splitCount++
    $left = $y-1
    $right = $y+1
    Move-Downward("${x}:${left}")
    Move-Downward("${x}:${right}")
  }
  else {
    $x++
    Move-Downward("${x}:${y}")
  }
}

function Find-Start {
  $x = 0
  $y = 0
  while ($f[$x][$y] -ne "S" -and $x -lt $maxX -and $y -lt $maxY) {
    $y++
  }
  return "${x}:${y}"
}

$start = Find-Start
Write-Host 'start' $start
Move-Downward($start)

Write-Host 'Part 1:' $splitCount