Measure-Command {
  $f = Get-Content .\2025\Day12\1.1.txt

  $SHAPES = @{}

  function ToRegion([string]$line) {
    $key, $matrix = $line -split ':'
    $width, $length = $key -Split 'x'
    $width = [uint64]$width
    $length = [uint64]$length
    return [PSCustomObject]@{
      x = $width
      y = $length
      size = $width * $length
      boxCount = [Math]::Floor($width/3)*[Math]::Floor($length/3)
      matrix = $matrix.Trim().Split()
    }
  }

  function ToShape([string[]]$rows) {
    $size = 0
    $display = ''
    foreach ($row in $rows) {
      $display += "$row`n"
      foreach($char in [char[]]$row) {
        if ($char -eq '#') {
          $size++
        }
      }
    }
    return [PSCustomObject]@{
      size = $size
      display = $display
    }
  }

  $i = 0
  while (-not $f[$i].Contains('x')) {
    # all shapes are in 3x3 grid
    $key = ($f[$i] -split ':')[0]
    $SHAPES[[int]$key] = ToShape($f[($i+1)..($i+4)])
    $i = $i+5
  }
  #Write-Host $SHAPES
  $fitCount = 0
  $notFitCount = 0
  $toBeChecked = @()
  while($i -lt $f.Length) {
    Write-Host $f[$i]
    $region = (ToRegion $f[$i])
    #Write-Host $region
    $boxCount = 0
    $minRequiredSize = 0
    for ($j = 0; $j -lt $region.matrix.Length; $j++) {
      $count = [int]($region.matrix[$j])
      $boxCount += $count
      $minRequiredSize += $count * $SHAPES[$j].size
    }
    Write-Host 'boxCount' $boxCount 'minReqSize' $minRequiredSize 'regionSize' $region.size 'regionBoxCount' $region.boxCount
    if ($region.size -lt $minRequiredSize) {
      $notFitCount++
    }
    elseif ($region.boxCount -ge $boxCount) {
      $fitCount++
    }
    else {
      $toBeChecked += $f[$i]
    }
    $i++
  }
  Write-Host 'Part 1:' $fitCount '+ (maybe)' + $toBeChecked.Count + ', but definitely not' + $notFitCount
}