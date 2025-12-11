Measure-Command {
  $f = Get-Content .\2025\Day11\1.0.txt

  $start = 'you'
  $end = 'out'
  $CACHE = @{}
  $GRAPH = @{}
  
  function To-End([string]$from) {
    if($CACHE[$from]) {
      return $CACHE[$from]
    }
    if ($from -eq $end) {
      return 1
    }
    $paths = 0
    foreach ($node in $GRAPH[$from]) {
      $paths += (To-End -from $node)
    }
    $CACHE[$from] = $paths
    return $paths
  }

  foreach ($line in $f) {
    $current, $followers = $line -split ':'
    $GRAPH[$current] = $followers.trim().split()
  }

  $pathCount = (To-End -from $start)

  Write-Host "Part 1:" $pathCount
}