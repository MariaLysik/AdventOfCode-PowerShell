Measure-Command {
  $f = Get-Content .\2025\Day9\1.1.txt
  $n = $f.Length

  $redTiles = @()
  $verticalEdges = @{}
  $horizontalEdges = @{}

  function ToPoint([string]$coords) {
    $x, $y = $coords -split ','
    return [PSCustomObject]@{
      x = [uint64]$x
      y = [uint64]$y
    }
  }

  function ToMinMax([uint64]$a, [uint64]$b) {
    if ($a -lt $b) {
      return [PSCustomObject]@{
        min = [uint64]$a
        max = [uint64]$b
      }
    }
    return [PSCustomObject]@{
      min = [uint64]$b
      max = [uint64]$a
    }
  }

  function Valid-Rectangle([PSCustomObject]$point1,[PSCustomObject]$point2) {
    $minX = [Math]::Min($point1.x, $point2.x)
    $maxX = [Math]::Max($point1.x, $point2.x)
    $minY = [Math]::Min($point1.y, $point2.y)
    $maxY = [Math]::Max($point1.y, $point2.y)
    $searchRange = $horizontalEdges.Keys | Where-Object { $_ -gt $minX -and $_ -lt $maxX }
    foreach($x in $searchRange) {
      $y = $horizontalEdges[[uint64]$x]
      if ($y.min -lt $maxY -and $y.max -gt $minY) {
        Write-Host 'intersecting horizontal' $x $y 'against' $point1 $point2
        return $false
      }
    }
    $searchRange = $verticalEdges.Keys | Where-Object { $_ -gt $minY -and $_ -lt $maxY }
    foreach($y in $searchRange) {
      $x = $verticalEdges[[uint64]$y]
      if ($x.min -lt $maxX -and $x.max -gt $minX) {
        Write-Host 'intersecting vertical' $x $y 'against' $point1 $point2
        return $false
      }
    }
    return $true
  }

  $prevPoint = ToPoint($f[$n-1])
  for($i = 0; $i -lt $n; $i++) {
    $curPoint = ToPoint($f[$i])
    $redTiles += $curPoint
    if ($curPoint.x -eq $prevPoint.x) {
      $horizontalEdges[$curPoint.x] = ToMinMax ($curPoint.y) ($prevPoint.y)
    }
    else {
      $verticalEdges[$curPoint.y] = ToMinMax ($curPoint.x) ($prevPoint.x)
    }
    $prevPoint = $curPoint
  }

  $maxArea = 0
  for($i = 0; $i -lt $n-1; $i++) {
    $p1 = $redTiles[$i]
    for($j = $i+1; $j -lt $n; $j++) {
      $p2 = $redTiles[$j]
      $currArea = ([Math]::Abs($p1.x-$p2.x)+1)*([Math]::Abs($p1.y-$p2.y)+1)
      if ($currArea -gt $maxArea) {
        if (Valid-Rectangle $p1 $p2) {
          Write-host 'updating area' $currArea 'for' $p1 $p2
          $maxArea = $currArea
        }
      }
    }
  }
  Write-Host 'Part 2:' $maxArea
}

# That's not the right answer; your answer is too low.
#Part 2: 1469113275