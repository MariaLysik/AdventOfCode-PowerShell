$f = Get-Content .\2025\Day4\1.1.txt
$rollsOfPaper = @{}

function Count-NeighbourRolls ([string]$coordinates) {
  $x, $y = $coordinates.Split(':')
  $countOfNeighbourRolls = 0
  @("$(1+$x):${y}","$(-1+$x):${y}","${x}:$(1+$y)","${x}:$(-1+$y)","$(1+$x):$(1+$y)","$(1+$x):$(-1+$y)","$(-1+$x):$(-1+$y)","$(-1+$x):$(1+$y)") | ForEach-Object {
    $countOfNeighbourRolls += $rollsOfPaper[$_]
  }
  return $countOfNeighbourRolls
}

for ($x = 0; $x -lt $f.Length; $x++) {
  for ($y = 0; $y -lt $f[0].Length; $y++) {
    if ($f[$x][$y] -eq '@') {
      $rollsOfPaper["${x}:${y}"] = 1
    }
  }
}

$accessedCount = 0
foreach ($roll in $rollsOfPaper.GetEnumerator()) {
  if ((Count-NeighbourRolls $roll.Key) -lt 4) {
    $accessedCount++
  }
}
Write-Host 'Part 1:' $accessedCount

$totalRemoved = 0
while($rollsOfPaper.Count) {
  $removed = 0
  $keys = @($rollsOfPaper.Keys)
  foreach ($roll in $keys) {
    if ((Count-NeighbourRolls $roll) -lt 4) {
      $rollsOfPaper.Remove($roll)
      $removed++
    }
  }
  if (-not $removed) {
    break
  }
  $totalRemoved += $removed
}
Write-Host 'Part 2:' $totalRemoved