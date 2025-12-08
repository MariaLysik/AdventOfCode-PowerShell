Measure-Command {
  $f = Get-Content .\2025\Day8\1.0.txt
  $connections = 10 # change to 1000 with real data
  $distances = @{}
  $boxes = @{}
  $circuits = @{}
  foreach ($coord in $f) {
    $x1, $y1, $z1 = $coord -split ','
    foreach($key in $boxes.Keys) {
      $x2, $y2, $z2 = $key -split ','
      $distance = [Math]::Pow(([int]$x1-[int]$x2),2) + [Math]::Pow(([int]$y1-[int]$y2),2) +  [Math]::Pow(([int]$z1-[int]$z2),2)
      if ($distances[$distance]) {
        Write-Host 'WARNING! same distance'
      }
      $distances[$distance] = @($coord,$key)
    }
    $boxes[$coord] = $null
  }

  foreach($distance in @($distances.Keys | Sort-Object | Select-Object -First $connections)) {
    if ($null -eq $boxes[$distances[$distance][0]] -and $null -eq $boxes[$distances[$distance][1]]) {
      #Write-Host 'merging to new circuit'
      $circuits[$distance] = $distances[$distance]
      $boxes[$distances[$distance][0]] = $distance
      $boxes[$distances[$distance][1]] = $distance
      continue
    }
    if ($boxes[$distances[$distance][0]] -eq $boxes[$distances[$distance][1]]) {
      #Write-Host 'skipping' $distances[$distance] 'are in the same circuit' $boxes[$distances[$distance][0]]
      continue
    }
    if ($null -eq $boxes[$distances[$distance][0]]) {
      #Write-Host 'merging to existing circuit'
      $circuits[$boxes[$distances[$distance][1]]] += $distances[$distance][0]
      $boxes[$distances[$distance][0]] = $boxes[$distances[$distance][1]]
    }
    elseif ($null -eq $boxes[$distances[$distance][1]]) {
      #Write-Host 'merging to existing circuit'
      $circuits[$boxes[$distances[$distance][0]]] += $distances[$distance][1]
      $boxes[$distances[$distance][1]] = $boxes[$distances[$distance][0]]
    }
    else {
      $leftBox = $boxes[$distances[$distance][0]]
      $rightBox = $boxes[$distances[$distance][1]]
      if ($circuits[$leftBox].Count -lt $circuits[$rightBox].Count) {
        $leftBox = $boxes[$distances[$distance][1]]
        $rightBox = $boxes[$distances[$distance][0]]
      }
      #Write-Host 'merging circuits' $leftBox "(" $circuits[$leftBox].Count ")" $rightBox "(" $circuits[$rightBox].Count ")"
      $circuits[$leftBox] = @($circuits[$leftBox]) + @($circuits[$rightBox])
      foreach ($box in $circuits[$rightBox]) {
        $boxes[$box] = $leftBox
      }
      $circuits.Remove($rightBox)
    }
  }

  $solution1 = 1
  $biggestThree = 3
  foreach($circuit in ($circuits.GetEnumerator() | Sort-Object { @($_.Value).Count } -Descending)) {
    $biggestThree--
    Write-Host $circuit.Key "(" $circuit.Value.Count ")" $circuit.Value
    $solution1 *= $circuit.Value.Count
    if($biggestThree -lt 1) {
      break
    }
  }
  Write-Host "Part 1:" $solution1
}