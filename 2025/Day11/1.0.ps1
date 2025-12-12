Measure-Command {
  $f = Get-Content .\2025\Day11\1.1.txt

  $CACHE = @{}
  $GRAPH = @{}
  
  function Count-Paths([string]$from,[string]$to) {
    $cacheKey = "${from}>${to}"
    if($CACHE[$cacheKey]) {
      return $CACHE[$cacheKey]
    }
    if ($from -eq $to) {
      return 1
    }
    $paths = 0
    foreach ($node in $GRAPH[$from]) {
      $paths += (Count-Paths -from $node -to $to)
    }
    $CACHE[$cacheKey] = $paths
    return $paths
  }

  foreach ($line in $f) {
    $current, $followers = $line -split ':'
    $GRAPH[$current] = $followers.trim().split()
  }

  Write-Host 'Part 1:' (Count-Paths -from 'you' -to 'out')
  Write-Host "Part 2:" ((Count-Paths -from 'svr' -to 'fft') * (Count-Paths -from 'fft' -to 'dac') * (Count-Paths -from 'dac' -to 'out'))
  #Write-Host "Part 2:" (Count-Paths -from 'svr' -to 'dac') * (Count-Paths -from 'dac' -to 'fft') * (Count-Paths -from 'fft' -to 'out')
}