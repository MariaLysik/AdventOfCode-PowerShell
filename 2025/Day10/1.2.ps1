Measure-Command {
  $f = Get-Content .\2025\Day10\1.1.txt

  function Get-Joltage([string]$line) {
    ($line  -match '\{(.*?)\}') | Out-Null
    $joltage = @()
    $matches[1] -split ',' | ForEach-Object {
      $joltage += [int]$_
    }
    return $joltage
  }

  function Get-Button([string]$positions,[int]$maskSize) {
    $mask = New-Object int[] ($maskSize)
    for ($i=0; $i -lt $maskSize; $i++) { $mask[$i] = 0 }
    $positions -split ',' | ForEach-Object {
      $mask[$_] = 1
    }
    return $mask
  }

  function Get-Buttons([string]$pattern,[int]$maskSize) {
    $masks = @()
    $buttons = [regex]::Matches($pattern, '\((?<round>[^()]+)\)') | ForEach-Object { $_.Groups['round'].Value }
    foreach ($button in $buttons) {
      $n = Get-Button $button $maskSize
      $masks += ,$n
    }
    return $masks
  }

  function Get-PowerSet ([object[]]$Items) {
    $n = $Items.Count
    for ($mask = 0; $mask -lt [math]::Pow(2, $n); $mask++) {
      $subset = @()
      for ($i = 0; $i -lt $n; $i++) {
        if ($mask -band (1 -shl $i)) {
          $subset += ,$Items[$i]
        }
      }
      ,$subset
    }
  }

  function Get-AllPatternsCosts($masks) {
    $maskSize = $masks[0].Length
    $PATTERNS = @{}
    Get-PowerSet $masks | ForEach-Object {
      $setLength = $_.Length
      $currentPattern = New-Object int[] ($maskSize)
      foreach ($buttonPress in $_) {
        for ($i = 0; $i -lt $maskSize; $i++) {
          $currentPattern[$i] += $buttonPress[$i]
        }
      }
      $parityPattern = [Convert]::ToInt16(@($currentPattern | ForEach-Object { $_%2 }) -join '', 2)
      if (-not $PATTERNS.ContainsKey($parityPattern)) {
        $PATTERNS[$parityPattern] = @{}
      }
      $currentPatterKey = $currentPattern -join ','
      if (-not $PATTERNS[$parityPattern].ContainsKey($currentPatterKey) -or $setLength -lt $PATTERNS[$parityPattern][$currentPatterKey]) {
        $PATTERNS[$parityPattern][$currentPatterKey] = $setLength
      }
    }
    return $PATTERNS
  }

  function Count-ButtonPresses($masks, $joltage) {
    $patternCosts = Get-AllPatternsCosts $masks
    $cache = @{}

    function Get-PatternCost($goal) {
      $cacheKey = $goal -join ','
      if ($cache.ContainsKey($cacheKey)) {
        return $cache[$cacheKey]
      }
      $allZero = -not ($goal | Where-Object { $_ -ne 0 })
      if ($allZero) {
        return 0
      }
      $cost = 1000000
      $parityKey = [Convert]::ToInt16(@($goal | ForEach-Object { $_%2 }) -join '', 2)
      if ($patternCosts.ContainsKey($parityKey)) {
        $patternCosts[$parityKey].GetEnumerator() | ForEach-Object {
          $pattern = @($_.Key -Split ',' | ForEach-Object { [int]$_ })
          $patternCost = $_.Value
          $valid = $true
          for ($i = 0; $i -lt $goal.Length; $i++) {
            if ($pattern[$i] -gt $goal[$i]) {
              $valid = $false
              break
            }
          }
          if ($valid) {
            $newGoal = New-Object int[] ($goal.Length)
            for ($i = 0; $i -lt $goal.Length; $i++) {
              $newGoal[$i] = ($goal[$i] - $pattern[$i]) / 2
            }
            $cost = [Math]::Min($cost, $patternCost + 2 * (Get-PatternCost $newGoal))
          }
        }
      }
      $cache[$cacheKey] = $cost
      return $cost
    }

    return Get-PatternCost $joltage
  }

  $totalButtonPresses = 0
  foreach ($line in $f) {
    $expected = Get-Joltage $line
    $buttons = Get-Buttons $line $expected.Length
    $buttonPresses = Count-ButtonPresses $buttons $expected
		Write-Host $line '>' $buttonPresses
		$totalButtonPresses += $buttonPresses
  }
  Write-Host "Part 2:" $totalButtonPresses
}