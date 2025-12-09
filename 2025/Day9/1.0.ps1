Measure-Command {
  $f = Get-Content .\2025\Day9\1.1.txt
  $n = $f.Length
  $maxArea = 0
  for($i = 0; $i -lt $n-1; $i++) {
    $x1, $y1 = $f[$i] -split ','
    $x1 = [uint64]$x1
    $y1 = [uint64]$y1
    for($j = $i+1; $j -lt $n; $j++) {
      $x2, $y2 = $f[$j] -split ','
      $x2 = [uint64]$x2
      $y2 = [uint64]$y2
      $currArea = ([Math]::Abs($x1-$x2)+1)*([Math]::Abs($y1-$y2)+1)
      if ($currArea -gt $maxArea) {
        $maxArea = $currArea
      }
    }
  }
  Write-Host 'Part 1:' $maxArea
}